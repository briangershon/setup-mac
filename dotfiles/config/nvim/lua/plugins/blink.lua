local gh = require('core.gh')

vim.pack.add {
  gh 'saghen/blink.lib',
  gh 'saghen/blink.cmp',
  gh 'rafamadriz/friendly-snippets', -- snippet collection for the snippets source
}

require('blink.cmp').setup {
  keymap = { preset = 'super-tab' },

  completion = {
    documentation = { auto_show = true },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = { implementation = 'prefer_rust_with_warning' },
}
