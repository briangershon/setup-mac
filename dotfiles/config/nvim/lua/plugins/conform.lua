local gh = require('core.gh')
local venv = require('core.venv')

vim.pack.add { gh 'stevearc/conform.nvim' }

-- The bundled ruff formatters hardcode `command = "ruff"`, i.e. whatever is on
-- PATH. Point them at the project's own copy instead, matching the language
-- server in after/lsp/ruff.lua. Overriding just `command` keeps conform's args,
-- stdin and cwd handling intact.
local ruff_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' }
local function venv_ruff(_, ctx) return venv.resolve(venv.root(ctx.buf, ruff_markers), 'ruff') or 'ruff' end

require('conform').setup {
  formatters_by_ft = {
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    graphql = { 'prettier' },
    python = { 'ruff_organize_imports', 'ruff_format' }, -- sort imports before formatting
  },
  formatters = {
    ruff_format = { command = venv_ruff },
    ruff_organize_imports = { command = venv_ruff },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = 'fallback',
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[C]ode [F]ormat' })
