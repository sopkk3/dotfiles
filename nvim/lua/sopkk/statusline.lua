vim.api.nvim_set_hl(0, 'greenFGblackBG', {ctermfg = 158, ctermbg = 0})

vim.o.statusline="%#greenFGblackBG#%{FugitiveStatusline()} %h%m%r %=%F %=%{&encoding} %y %{&ff} %-8.(%l,%c%V%) %P"
vim.o.winbar="%#greenFGblackBG# %{winnr()} %f%m"
-- vim.o.tabline needs to iterate through tabs
