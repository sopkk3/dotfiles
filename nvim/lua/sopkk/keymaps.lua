local opts = { noremap = true, silent = true }

local mappings = {
  {'n', '<leader>ww', ':w<CR>'},
  {'n', '<leader>q', ':q<CR>'},
  {'n', '<leader>aq', ':q!<CR>'},
  {'n', '<leader>Q', ':qa<CR>'},
  {'n', '<leader>aQ', ':qa!<CR>'},
  {'n', 'n', 'nzz'},
  {'n', 'N', 'Nzz'},
  {'n', 'J', 'mxJ`x'},
  {'n', 'Y', 'y$'},
  {'n', '<leader>E', ':Explore<CR>'},
  {'n', '<Up>', '<C-y>'},
  {'n', '<Down>', '<C-e>'},

  -- Buffers, tabs and qfix list
  {'n', '<leader>n', ':bnext<CR>'},
  {'n', '<leader>bd', ':bd<CR>'},
  {'n', '<leader>DD', ':call delete(expand("%")) | bdelete!<CR>'},
  {'n', '<Left>', 'gT'},
  {'n', '<Right>', 'gt'},
  {'n', '<C-j>', ':cnext<CR>zz'},
  {'n', '<C-k>', ':cprev<CR>zz'},
  {'n', '<A-.>', '<C-W>>'},
  {'n', '<A-,>', '<C-W><'},
  {'n', '<A-m>', '<C-W>+'},
  {'n', '<A-n>', '<C-W>-'},
  {'n', '<leader>os', ':set scrollbind!<CR>'},
  {'n', '<leader>tn', ':tabnew<CR>'},

  {'n', ']<Space>', ':m .-2<CR>=='},
  {'v', ']<Space>', ':m .-2<CR>==gv'},
  {'n', '[<Space>', ':m .+1<CR>=='},
  -- {'v', '[<Space>', ':m >+1<CR>==gv'}, error

  {'n', '<leader>dd', ':.!base64 -d<CR>'},
  {'n', '<leader>de', ':.!base64<CR>'},
  {'n', '<leader>dj', ':.!jq<CR>'},

  -- Clipboard access is needed :help clipboard
  {{ 'n', 'v' }, '<Leader>y', '"+y'},
  {'n', '<Leader>p', '"+p'},
  {'v', '<Leader>p', '"_d"+P'},
  {'v', 'p', '"_dP'},

  {'t', '<C-x>', '<C-\\><C-n>'},

  -- fugitive
  {'n', '<leader>G', ':G<CR><C-w>5-'},
  {'n', '<Leader>gb', ':G blame<CR>'},
  {'n', '<Leader>gp', ':G push<CR>'},
  {'n', '<Leader>gl', ':G pull<CR>'},
  {'n', '<Leader>gs', ':G switch -<CR>'},

  -- vim wiki
  {'n', '<leader>WW', ':VimwikiIndex<CR>'},
  {'n', '<leader>wc', ':VimwikiToggleListItem<CR>'},

  -- harpoon
  {'n', '<leader>ad', ':lua require("harpoon.mark").add_file()<CR>'},
  {'n', '<leader>l', ':lua require("harpoon.ui").toggle_quick_menu()<CR>'},
  {'n', '<leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>'},
  {'n', '<leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>'},
  {'n', '<leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>'},
  {'n', '<leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>'},
  {'n', '<leader>t1', ':lua require("harpoon.term").gotoTerminal(1)<CR>'},
}

for _, v in pairs(mappings) do
  vim.keymap.set(v[1], v[2], v[3], opts)
end
