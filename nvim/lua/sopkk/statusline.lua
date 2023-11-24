vim.api.nvim_set_hl(0, 'greenFGblackBG', {ctermfg = 158, ctermbg = 234})
vim.api.nvim_set_hl(0, 'greenFGwhiteBG', {ctermfg = 0, ctermbg = 231})

if vim.o.background == "light" then
  vim.o.statusline="%#greenFGwhiteBG#%{FugitiveStatusline()} %h%m%r %=%F %=%{&encoding} %y %{&ff} %-8.(%l,%c%V%) %P"
  vim.o.winbar="%#greenFGwhiteBG# %{winnr()} %f%m"
else
  vim.o.statusline="%#greenFGblackBG#%{FugitiveStatusline()} %h%m%r %=%F %=%{&encoding} %y %{&ff} %-8.(%l,%c%V%) %P"
  vim.o.winbar="%#greenFGblackBG# %{winnr()} %f%m"
end
-- vim.o.tabline needs to iterate through tabs
