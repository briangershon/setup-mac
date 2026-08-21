-- Ruff's language server: lint diagnostics and autofixes.
--
-- NOTE: this lives in `after/lsp/` rather than `lsp/`. Nvim merges every
-- `lsp/<name>.lua` on the runtimepath with `tbl_deep_extend('force')` in
-- runtimepath order, so *later wins* — and nvim-lspconfig sits at position 9
-- while `~/.config/nvim` is position 1. From `lsp/` our `cmd` would be silently
-- replaced by lspconfig's plain `{ 'ruff', 'server' }`. `after/` is last (43),
-- which is exactly what `:h lsp-config` recommends for overriding a plugin.
--
-- No `settings` here on purpose: ruff reads the project's own pyproject.toml /
-- ruff.toml, which is the whole reason we run the project's copy. Should server
-- settings ever be needed, they go under `init_options.settings` for this server.
local venv = require('core.venv')

local config = venv.server {
  exe = 'ruff',
  args = { 'server' },
  markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  install = 'uv tool install ruff',
}

-- Ruff would otherwise negotiate utf-8 while basedpyright only speaks utf-16.
-- Both attach to the same buffer, and mismatched encodings make the two servers
-- count columns differently on any line containing non-ASCII text, so
-- diagnostics and code action ranges land in the wrong place. Restricting ruff
-- to utf-16 keeps them in agreement. Only the encoding list is replaced here;
-- the blink.cmp capabilities from `vim.lsp.config('*', ...)` still merge in.
config.capabilities = {
  general = { positionEncodings = { 'utf-16' } },
}

---@type vim.lsp.Config
return config
