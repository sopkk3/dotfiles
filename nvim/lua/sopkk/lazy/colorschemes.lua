return {
  {
    'wuelnerdotexe/vim-enfocado',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme enfocado')
      local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
      end

      -- find hl groups: <cmd>filter /search/ highlight
      -- :filter /line/ highlight
      -- 250 default white #bcbcbc
      -- 234 default bg black #1c1c1c
      -- bg 0 for high contrast

      -- hl('NormalNC', { bg = 232, }) -- non active
      hl('Normal', { fg = '#bcbcbc', bg = '#1c1c1c' })

      hl('NormalFloat', { fg = '#bcbcbc', bg = '#1c1c1c', })
      hl('FloatBorder', { fg = '#87af5f', bg = '#1c1c1c', })

      hl('LineNrBelow', { fg = '#949494', bg = '#1c1c1c', })
      hl('LineNrAbove', { fg = '#949494', bg = '#1c1c1c', })
      hl('CursorLineNr', { fg = '#e4e4e4', bg = '#1c1c1c', })

      hl('Search', { fg = '#ffaf00', bg = '#1c1c1c', })

      hl('CursorLine', { bg = '#303030', })
      hl('ColorColumn', { bg = '#303030', })

      hl('NonText', { fg = '#767676', })

      -- -- hl('@markup.heading', { link = 'Title' }) -- @markup.heading shares group with pipe_table_header
      hl('@markup.heading.1', { fg = '#5f8787', bold = true })
      hl('@markup.heading.2', { fg = '#5f8787', bold = true })
      hl('@markup.heading.3', { fg = '#5f8787', bold = true })
      hl('@markup.link.label', { link = 'SpecialChar' }) -- '#b891f5', 141
      hl('@markup.link.url', { link = 'Underlined' })
      hl('@markup.list', { fg = '#5f87ff' })
      hl('@markup.strong', { bold = true })


      -- disable 0.9 lsp highlight | @lsp.type.*
      for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
      end
    end,
  },
  -- 'folke/tokyonight.nvim',
  -- 'EdenEast/nightfox.nvim',
  -- 'blazkowolf/gruber-darker.nvim',
}
