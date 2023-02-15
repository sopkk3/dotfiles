local opts = { noremap = true, silent = true }

local harp_ui = require('harpoon.ui')
local harp_mark = require('harpoon.mark')
local harp_term = require('harpoon.term')

-- TODO: function to run `column` and then indent same lines
-- local function indentSelection()
--   local line1 = vim.api.nvim_buf_get_mark(0, "<")[1]
--   local line2 = vim.api.nvim_buf_get_mark(0, ">")[1]
-- end

local mappings = {
  {'n', '<leader>ww', ':update<CR>'},
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
  {'n', '<leader>w1', '1<C-w>w'},
  {'n', '<leader>w2', '2<C-w>w'},
  {'n', '<leader>w3', '3<C-w>w'},
  {'n', '<leader>w4', '4<C-w>w'},


  -- Buffers, tabs and qfix list
  {'n', ']b', ':bnext<CR>'},
  {'n', '[b', ':bnext<CR>'},
  {'n', '<leader>bd', ':bd<CR>'},
  {'n', '<leader>DD', ':call delete(expand("%")) | bdelete!<CR>'},
  {'n', '<Left>', 'gT'},
  {'n', '<Right>', 'gt'},
  {'n', '[q', ':cprev<CR>zz'},
  {'n', ']q', ':cnext<CR>zz'},
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

  {'n', '[d', ':.!base64<CR>'},
  {'n', ']d', ':.!base64 -d<CR>'},
  {'n', ']j', ':.!jq<CR>'},
  {'v', '[=', [[:'<,'>! column -t | sed 's/ = /=/'<CR>]]},

  -- Clipboard access is needed :help clipboard
  {{ 'n', 'v' }, '<Leader>y', '"+y'},
  {'n', '<Leader>p', '"+p'},
  {'v', '<Leader>p', '"_d"+P'},
  {'v', 'p', '"_dP'},

  {'t', '<C-x>', '<C-\\><C-n>'},
  {'t', '<Esc>', '<C-\\><C-n>'},

  -- fugitive
  {'n', '<leader>G', ':G<CR>'},
  {'n', '<Leader>gb', ':G blame<CR>'},
  {'n', '<Leader>gp', ':G push<CR>'},
  {'n', '<Leader>gl', ':G pull<CR>'},
  {'n', '<Leader>gs', ':G switch -<CR>'},

  -- vim wiki
  {'n', '<leader>WW', ':VimwikiIndex<CR>'},
  {'n', '<leader>wc', ':VimwikiToggleListItem<CR>'},

  -- harpoon
  {'n', '<leader>ad', function() harp_mark.add_file() end},
  {'n', '<leader>l', harp_ui.toggle_quick_menu},
  {'n', '<leader>1', function() harp_ui.nav_file(1) end},
  {'n', '<leader>2', function() harp_ui.nav_file(2) end},
  {'n', '<leader>3', function() harp_ui.nav_file(3) end},
  {'n', '<leader>4', function() harp_ui.nav_file(4) end},
  {'n', '<leader>t1', function() harp_term.gotoTerminal(1) end},

  -- luasnip
  {'n', '<leader><leader>s', '<cmd>source ~/.config/nvim/lua/sopkk/luasnip.lua<CR>'},
}

for _, v in pairs(mappings) do
  vim.keymap.set(v[1], v[2], v[3], opts)
end
