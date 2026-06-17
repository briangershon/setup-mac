local gh = require('core.gh')

vim.pack.add { gh 'stevearc/conform.nvim' }

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
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = 'fallback',
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[C]ode [F]ormat' })
