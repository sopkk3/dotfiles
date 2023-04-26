vim.g.sopkk_colorscheme = 'enfocado'
-- vim.g.sopkk_colorscheme = 'nightfly'
-- vim.g.sopkk_colorscheme = 'tokyonight-storm' -- blue

vim.cmd('colorscheme ' .. vim.g.sopkk_colorscheme)

local hl = function(thing, opts)
  vim.api.nvim_set_hl(0, thing, opts)
end

if vim.g.sopkk_colorscheme == 'enfocado' then

  hl('NormalFloat', { ctermfg = 250, ctermbg = 234, })
  hl('FloatBorder', { ctermfg = 107, ctermbg = 234, })

  hl('LineNrBelow', { ctermfg = 246, ctermbg = 234, })
  hl('LineNrAbove', { ctermfg = 246, ctermbg = 234, })
  hl('CursorLineNr', { ctermfg = 254, ctermbg = 234, })

  hl('Search', { ctermfg = 214, ctermbg = 234, })

  hl('CursorLine', { ctermbg = 238, })
  hl('ColorColumn', { ctermbg = 238, })

  -- disable 0.9 lsp highlight temporarily
  -- https://www.reddit.com/r/neovim/comments/12gvms4/this_is_why_your_higlights_look_different_in_90/
  for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
    vim.api.nvim_set_hl(0, group, {})
  end

end

-- hl('Normal', { ctermbg = 234, }) -- background
-- hl('NormalNC', { ctermbg = 234, }) -- background non active windows
