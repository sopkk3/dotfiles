if not pcall(require, 'luasnip') then
  return
end

local ls = require('luasnip')
local types = require('luasnip.util.types')
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep
local i = ls.insert_node

ls.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <- Current Choice", "NonTest" } },
      },
    },
  },
}

vim.keymap.set({ 'i', 's' }, '<C-k>', function()
    -- vim.api.nvim_echo({{'first chunk and ', 'None'}, {'second chunk to echo', 'None'}}, false, {})
    --   vim.cmd('echom "none"')
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end)

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)

vim.keymap.set('i', '<C-h>', function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)

ls.snippets = {
  lua = {
    ls.s('req', fmt('local {} = require("{}")', { i(1, 'default'), rep(1)})),
  },
}

-- vim.keymap.set('n', '<leader><leader>s', ':source ~/.dotfiles/vim/lua/sopkk/luasnip.lua<CR>')
