vim.opt_local.wrap = false
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>WC', 'mx0f[lrx<Esc>`x', opts)
vim.keymap.set('n', '<leader>WD', 'mx0f[fxr<Space><Esc>`x', opts)
