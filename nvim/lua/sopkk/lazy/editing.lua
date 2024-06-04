return {
  {
    'echasnovski/mini.surround',
    config = function()
      require('mini.surround').setup({
        custom_surroundings = {
          ['('] = { output = { left = '( ', right = ' )' } },
          ['['] = { output = { left = '[ ', right = ' ]' } },
          ['{'] = { output = { left = '{ ', right = ' }' } },
          ['<'] = { output = { left = '< ', right = ' >' } },
        },
        mappings = {
          add = 'ys',
          delete = 'ds',
          find = '',
          find_left = '',
          highlight = '',
          replace = 'cs',
          update_n_lines = '',
        },
        search_method = 'cover_or_next',
      })
    end,
    opts = {},
  },
  {
    'ThePrimeagen/harpoon',
    keys = {
      { '<leader>ad', function() require('harpoon.mark').add_file() end },
      { '<leader>l', function() require('harpoon.ui').toggle_quick_menu() end },
      { '<leader>1', function() require('harpoon.ui').nav_file(1) end },
      { '<leader>2', function() require('harpoon.ui').nav_file(2) end },
      { '<leader>3', function() require('harpoon.ui').nav_file(3) end },
      { '<leader>4', function() require('harpoon.ui').nav_file(4) end },
      { '<leader>5', function() require('harpoon.ui').nav_file(5) end },
      { '<leader>6', function() require('harpoon.ui').nav_file(6) end },
      { '<leader>t1', function() require('harpoon.term').gotoTerminal(1) end },
      { '<leader>t2', function() require('harpoon.term').gotoTerminal(2) end },
    },
  }
}
