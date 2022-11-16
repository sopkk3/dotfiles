vim.g.sopkk_colorscheme = 'enfocado'
-- vim.g.sopkk_colorscheme = 'tokyonight' -- make normal bg same as NormalFloat

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

end

hl('CursorLine', { ctermbg = 238, })
hl('ColorColumn', { ctermbg = 238, })
