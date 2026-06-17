vim.g.nord_contrast = true
vim.g.nord_borders = false
vim.g.nord_disable_background = true
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false
require('nord').set()

-- Same color family as comments, but italic so hints are still
-- visually distinct from real comments.
local comment_hl = vim.api.nvim_get_hl(0, { name = 'Comment' })
vim.api.nvim_set_hl(0, 'LspInlayHint', vim.tbl_extend('force', comment_hl, { italic = true }))
