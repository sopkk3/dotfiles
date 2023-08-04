vim.g.sopkk_colorscheme = 'enfocado'
-- vim.g.sopkk_colorscheme = 'tokyonight-storm' -- blue

vim.cmd('colorscheme ' .. vim.g.sopkk_colorscheme)

local hl = function(thing, opts)
  vim.api.nvim_set_hl(0, thing, opts)
end

-- hl('Normal', { ctermbg = 234, }) -- background
-- hl('NormalNC', { ctermbg = 234, }) -- background non active windows
if vim.g.sopkk_colorscheme == 'enfocado' then
  -- 250 default white
  -- 234 default bg black

  hl('Normal', { ctermfg = 250, ctermbg = 232 })

  hl('NormalFloat', { ctermfg = 250, ctermbg = 0, })
  hl('FloatBorder', { ctermfg = 107, ctermbg = 0, })

  hl('LineNrBelow', { ctermfg = 246, ctermbg = 0, })
  hl('LineNrAbove', { ctermfg = 246, ctermbg = 0, })
  hl('CursorLineNr', { ctermfg = 254, ctermbg = 0, })

  hl('Search', { ctermfg = 214, ctermbg = 0, })

  hl('CursorLine', { ctermbg = 238, })
  hl('ColorColumn', { ctermbg = 238, })

  -- disable 0.9 lsp highlight temporarily
  -- https://www.reddit.com/r/neovim/comments/12gvms4/this_is_why_your_higlights_look_different_in_90/
  for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
    vim.api.nvim_set_hl(0, group, {})
  end

end
