return {
  'L3MON4D3/LuaSnip',
  keys = {
    { '<leader><leader>s', '<cmd>source ~/.config/nvim/lua/sopkk/lazy/snippets.lua<CR>' },
  },
  config = function ()
    local ls = require('luasnip')
    local types = require('luasnip.util.types')
    local fmt = require('luasnip.extras.fmt').fmt
    local snippet = ls.snippet
    local i = ls.insert_node
    local f = ls.function_node

    ls.config.set_config {
      history = true,
      updateevents = 'TextChanged,TextChangedI',
      enable_autosnippets = true,

      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { ' <- ', 'NonTest' } },
          },
        },
      },
    }

    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end)

    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end)

    vim.keymap.set({ 'i', 's' }, '<C-l>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end)

    -- GLOBAL {{
      ls.add_snippets( 'all', {
        ls.parser.parse_snippet('tern', '${1:condition} ? ${2:true} : ${0:false}'),

        snippet('todo', fmt([[TODO({}): {}]], { i(1, 'who'), i(0, 'what')}) ),

      }, {
        key = 'all',
      })
      -- }}

      -- WIKI {{
        ls.add_snippets( 'markdown', {
          snippet('daily', fmt("{}\n  - ", {f(
          function ()
            return os.date "%Y/%m/%d"
          end)}
          )
          )
        }, {
          key = 'wiki'
        })
        -- }}
      end
    }
