local opts = { noremap = true, silent = true }

local function encode64()
  local lineContent = vim.api.nvim_get_current_line()
  local output = vim.fn.system("echo -n '" .. lineContent .. "'| base64")
  local newLineContent = output:gsub("\n", "")
  vim.api.nvim_set_current_line(newLineContent)
end

local function openSplitBelow()
  vim.cmd('belowright 20split')
end

local mappings = {
  {'n', '<leader>ww', '<cmd>update<CR>'},
  {'n', '<leader>q', '<cmd>q<CR>'},
  {'n', '<leader>aq', '<cmd>q!<CR>'},
  {'n', '<leader>QQ', '<cmd>qa<CR>'},
  {'n', '<leader>QW', '<cmd>tabclose<CR>'},
  {'n', '<leader>aQ', '<cmd>qa!<CR>'},
  {'n', 'J', 'mxJ`x'},
  {'n', 'Y', 'y$'},
  {'i', '<C-c>', '<Esc>'},
  {'n', '<leader>E', '<cmd>Explore<CR>'},
  {'n', '<Up>', '<C-y>'},
  {'n', '<Down>', '<C-e>'},
  {'n', '*', '*N'},
  {'n', '<leader>w1', '1<C-w>w'},
  {'n', '<leader>w2', '2<C-w>w'},
  {'n', '<leader>w3', '3<C-w>w'},
  {'n', '<leader>w4', '4<C-w>w'},
  {'t', '<C-x>', '<C-\\><C-n>'},
  {'t', '<Esc>', '<C-\\><C-n>'},

  -- Folding
  {'n', '[z', 'zfi{'},
  {'n', ']z', 'za'},

  -- Buffers, tabs and qfix list
  {'n', ']b', '<cmd>bnext<CR>'},
  {'n', '[b', '<cmd>bnext<CR>'},
  {'n', '<leader>bd', '<cmd>bd<CR>'},
  {'n', '<leader>DD', '<cmd>call delete(expand("%")) | bdelete!<CR>'},
  {'n', '<Left>', 'gT'},
  {'n', '<Right>', 'gt'},
  {'n', '[q', '<cmd>cprev<CR>zz'},
  {'n', ']q', '<cmd>cnext<CR>zz'},
  {'n', '<A-.>', '<C-W>>'},
  {'n', '<A-,>', '<C-W><'},
  {'n', '<A-m>', '<C-W>+'},
  {'n', '<A-n>', '<C-W>-'},
  {'n', '<leader>os', '<cmd>set scrollbind!<CR>'},
  {'n', '<leader>tn', '<cmd>tabnew<CR>'},
  {'n', '<leader>tt', openSplitBelow},

  {'n', ']<Space>', '<cmd>m .-2<CR>=='},
  {'v', ']<Space>', [[:move '<-2<CR>gv=gv]]},
  {'n', '[<Space>', '<cmd>m .+1<CR>=='},
  {'v', '[<Space>', [[:move '>+1<CR>gv=gv]]},

  -- Decode/Encode
  {'n', '[d', encode64}, -- <cmd>.!base64<CR> line ending also encoded
  {'n', ']d', '<cmd>.!base64 -d<CR>'},
  {'n', ']j', '<cmd>.!jq<CR>'},
  {'v', '[=', [[:'<,'>! column -t | sed 's/ = /=/'<CR>]]},
  -- {'v', ']=', alignOnChar},
  {'n', ']c', '<cmd>!openssl x509 -in % -noout -text<CR>'},

  -- Clipboard access is needed :help clipboard
  {{ 'n', 'v' }, '<leader>y', '"+y'},
  {'n', '<leader>p', '"+p'},
  {'v', '<leader>p', '"_d"+P'},
  {'v', 'p', '"_dP'},
  {'n', '<leader>cf', '<cmd>let @+ = expand("%")<CR>'}, -- copies file path | :h expand

}

for _, v in pairs(mappings) do
  vim.keymap.set(v[1], v[2], v[3], opts)
end
