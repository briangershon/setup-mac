---Resolve Python tooling out of a project's own virtualenv.
---
---Unlike the Mason-managed servers in `lua/plugins/lsp.lua`, Python tools are
---version-coupled to the project they run against: ruff's `[tool.ruff]` keys and
---rule sets shift between releases, so one global copy would silently disagree
---with any repo that pins an older version. Everything here exists to prefer the
---project's `.venv` and only fall back to a `uv tool install`ed copy on PATH.
local M = {}

---@param bufnr integer
---@param markers string[]
---@return string? root
function M.root(bufnr, markers) return vim.fs.root(bufnr, markers) end

---Locate `exe`, preferring the project venv over anything global.
---@param root string? Project root, as decided by `M.root`
---@param exe string Executable name, e.g. 'ruff'
---@return string? path Absolute path, or nil if `exe` exists nowhere
function M.resolve(root, exe)
  local venvs = {}
  if root then table.insert(venvs, root .. '/.venv') end
  if vim.env.VIRTUAL_ENV then table.insert(venvs, vim.env.VIRTUAL_ENV) end

  for _, venv in ipairs(venvs) do
    local path = venv .. '/bin/' .. exe
    if vim.uv.fs_stat(path) then return path end
  end

  local found = vim.fn.exepath(exe)
  return found ~= '' and found or nil
end

---Build the `root_dir`/`cmd` pair that a venv-aware `vim.lsp.Config` needs.
---
---`root_dir` does double duty: it decides the workspace root *and* gates
---activation, because `:h lsp-root_dir()` skips the server entirely when
---`on_dir` is never called. That gives us a quiet no-op in projects where the
---tool isn't installed, instead of a spawn failure in every Python buffer.
---@param opts { exe: string, args: string[], markers: string[], install: string }
---@return vim.lsp.Config
function M.server(opts)
  -- Stashed by root_dir so cmd doesn't repeat the filesystem walk. `cmd` is
  -- handed the already-resolved root, so it's a safe key to share on.
  local exe_by_root = {}

  return {
    root_dir = function(bufnr, on_dir)
      local root = M.root(bufnr, opts.markers)
      local exe = M.resolve(root, opts.exe)
      if not exe then
        vim.notify_once(
          ('%s not found in .venv/bin, $VIRTUAL_ENV or PATH — install it with `%s`'):format(opts.exe, opts.install),
          vim.log.levels.WARN
        )
        return -- no on_dir() call, so the server never starts for this buffer
      end

      exe_by_root[root or ''] = exe
      on_dir(root) -- a nil root is fine: standalone .py files still attach
    end,

    cmd = function(dispatchers, config)
      local exe = exe_by_root[config.root_dir or ''] or opts.exe
      local cmd = vim.list_extend({ exe }, opts.args)
      return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.root_dir })
    end,
  }
end

return M
