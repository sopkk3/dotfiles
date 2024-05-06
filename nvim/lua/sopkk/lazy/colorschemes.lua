return {
  { 'wuelnerdotexe/vim-enfocado',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme enfocado')
      local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
      end

      -- find hl groups: <cmd>filter /search/ highlight
      -- :filter /line/ highlight
      if vim.o.background ~= "light" then
        -- 250 default white #bcbcbc
        -- 234 default bg black
        -- bg 0 for high contrast

        -- hl('NormalNC', { ctermbg = 232, }) -- non active
        hl('Normal', { ctermfg = 250, ctermbg = 234 })

        hl('NormalFloat', { ctermfg = 250, ctermbg = 234, })
        hl('FloatBorder', { ctermfg = 107, ctermbg = 234, })

        hl('LineNrBelow', { ctermfg = 246, ctermbg = 234, })
        hl('LineNrAbove', { ctermfg = 246, ctermbg = 234, })
        hl('CursorLineNr', { ctermfg = 254, ctermbg = 234, })

        hl('Search', { ctermfg = 214, ctermbg = 234, })

        hl('CursorLine', { ctermbg = 238, })
        hl('ColorColumn', { ctermbg = 238, })

        hl('NonText', { ctermfg = 243, })

        -- hl('@markup.heading', { link = 'Title' }) -- @markup.heading shares group with pipe_table_header
        hl('@markup.heading.1', { ctermfg = 66, bold = true })
        hl('@markup.heading.2', { ctermfg = 66, bold = true })
        hl('@markup.heading.3', { ctermfg = 66, bold = true })
        hl('@markup.link.label', { link = 'SpecialChar' })
        hl('@markup.link.url', { link = 'Underlined' })
        hl('@markup.list', { ctermfg = 69 })
        hl('@markup.strong', { bold = true })

      end

      -- disable 0.9 lsp highlight
      -- https://www.reddit.com/r/neovim/comments/12gvms4/this_is_why_your_higlights_look_different_in_90/
      for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
      end
    end,
  },
  -- 'folke/tokyonight.nvim',
  -- 'EdenEast/nightfox.nvim',
  -- 'blazkowolf/gruber-darker.nvim',
}
