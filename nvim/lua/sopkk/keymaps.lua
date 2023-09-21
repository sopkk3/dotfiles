local opts = { noremap = true, silent = true }

local harp_ui = require('harpoon.ui')
local harp_mark = require('harpoon.mark')
local harp_term = require('harpoon.term')

local function wikiTable()
  local columns = vim.fn.input("Number of columns: ")
  local rows = vim.fn.input("Number of rows: ")
  vim.api.nvim_command('VimwikiTable ' .. columns .. ' ' .. rows)
end

local function openTerminalBelow()
  vim.cmd('belowright 20split')
  harp_term.gotoTerminal(1)
end

local function encode64()
  local lineContent = vim.api.nvim_get_current_line()
  local output = vim.fn.system("printf " .. lineContent .. "| base64")
  local newLineContent = output:gsub("\n", "")
  vim.api.nvim_set_current_line(newLineContent)
end


local mappings = {
  {'n', '<leader>ww', '<cmd>update<CR>'},
  {'n', '<leader>q', '<cmd>q<CR>'},
  {'n', '<leader>aq', '<cmd>q!<CR>'},
  {'n', '<leader>QQ', '<cmd>qa<CR>'},
  {'n', '<leader>QW', '<cmd>tabclose<CR>'},
  {'n', '<leader>aQ', '<cmd>qa!<CR>'},
  {'n', 'n', 'nzz'},
  {'n', 'N', 'Nzz'},
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
  {'n', '[z', 'zfi{'}, -- TODO: Make fold work based on indentation blocks
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
  {'n', '<leader>tt', openTerminalBelow},

  {'n', ']<Space>', '<cmd>m .-2<CR>=='},
  {'v', ']<Space>', '<cmd>m .-2<CR>==gv'},
  {'n', '[<Space>', '<cmd>m .+1<CR>=='},
  -- {'v', '[<Space>', '<cmd>m >+1<CR>==gv'}, error

  -- Decode/Encode
  {'n', '[d', encode64}, -- <cmd>.!base64<CR> line ending also encoded
  {'n', ']d', '<cmd>.!base64 -d<CR>'},
  {'n', ']j', '<cmd>.!jq<CR>'},
  {'v', '[=', [[<cmd>'<,'>! column -t | sed 's/  / /'<CR>]]},
  -- {'v', ']=', alignOnChar},
  {'n', ']c', '<cmd>!openssl x509 -in % -noout -text<CR>'},

  -- Clipboard access is needed :help clipboard
  {{ 'n', 'v' }, '<leader>y', '"+y'},
  {'n', '<leader>p', '"+p'},
  {'v', '<leader>p', '"_d"+P'},
  {'v', 'p', '"_dP'},
  {'n', '<leader>cf', '<cmd>let @+ = expand("%")<CR>'}, -- copies file path | :h expand

  -- git / fugitive
  {'n', '<leader>G', '<cmd>G<CR>'},
  {'n', '<leader>gb', '<cmd>G blame<CR>'},
  {'n', '<leader>gp', '<cmd>G push<CR>'},
  {'n', '<leader>gl', '<cmd>G pull<CR>'},
  {'n', '<leader>gs', '<cmd>G switch -<CR>'},
  {'n', '<leader>gd', '<cmd>DiffviewOpen '},

  -- vim wiki
  {'n', '<leader>WW', '<cmd>VimwikiIndex<CR>'},
  {'n', '<leader>WC', '<cmd>VimwikiToggleListItem<CR>'},
  {'n', '<leader>WT', wikiTable},

  -- harpoon
  {'n', '<leader>ad', function() harp_mark.add_file() end},
  {'n', '<leader>l', harp_ui.toggle_quick_menu},
  {'n', '<leader>1', function() harp_ui.nav_file(1) end},
  {'n', '<leader>2', function() harp_ui.nav_file(2) end},
  {'n', '<leader>3', function() harp_ui.nav_file(3) end},
  {'n', '<leader>4', function() harp_ui.nav_file(4) end},
  {'n', '<leader>t1', function() harp_term.gotoTerminal(1) end},
  {'n', '<leader>t2', function() harp_term.gotoTerminal(2) end},

  -- luasnip
  {'n', '<leader><leader>s', '<cmd>source ~/.config/nvim/lua/sopkk/luasnip.lua<CR>'},

  -- lsp
  {'n', '<leader>LR', '<cmd>LspRestart<CR>'},
}

for _, v in pairs(mappings) do
  vim.keymap.set(v[1], v[2], v[3], opts)
end

local builtin = require("telescope.builtin")

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufopts = { noremap=true, silent=true, buffer=ev.buf }

    -- https://github.com/nvim-telescope/telescope.nvim#neovim-lsp-pickers
    -- :h vim.lsp
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, bufopts)
    vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>gr', builtin.lsp_references)
    vim.keymap.set('i', '<C-l>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', 'gF', function()
      vim.lsp.buf.format { async = true }
    end, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next, bufopts)

  end,
})
