local options = {
  completeopt = { 'menu', 'menuone', 'noselect' },
  encoding = 'utf-8',
  backup = false,
  writebackup = false,
  swapfile = false,
  mouse = 'nv',

  ignorecase = true,
  smartcase = true,
  smartindent = true,
  relativenumber = true,
  number = true,
  updatetime = 1000,
  splitright = true,
  joinspaces = false,
  wrap = true,
  breakindent = true,
  showbreak = string.rep(" ", 3),
  linebreak = true,
  list = true,
  listchars = { trail = '·', tab = '>>', nbsp = '␣' },

  scrolloff = 10,
  sidescrolloff = 5,
  cursorline = true,

  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,

  laststatus = 3,
}

vim.opt.wildignore:append('*/node_modules/*,*/target/*,*/.out,*/.git/*,*.swp')

vim.g.netrw_banner = 0
vim.g.jsonnet_fmt_on_save = 0

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.filetype.add({
  pattern = {
    ['.*Jenkinsfile.*'] = 'groovy',
    ['.*tf'] = 'terraform',
    ['.*terraform'] = 'terraform',
    ['.*tfvars'] = 'terraform',
    ['.*%.yaml.*'] = 'yaml'
  }
})


local group = vim.api.nvim_create_augroup('OptionsGroup', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWritePre' }, { group = group,  command = '%s/\\s\\+$//e'})
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = group,
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 300 }
  end,
})

local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline('WinLeave', false)
set_cursorline('WinEnter', true)
set_cursorline('FileType', false, 'TelescopePrompt')

vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'FocusGained' }, {
  group = group,
  desc = 'git branch',
  callback = function()
    if vim.fn.isdirectory '.git' ~= 0 then
      local branch = vim.fn.system "git branch --show-current | tr -d '\n'"
      vim.b.branch_name = '  ' .. branch .. ' '
    else
      vim.b.branch_name = ''
    end
  end,
})

vim.api.nvim_set_hl(0, 'greenFGblackBG', {ctermfg = 158, ctermbg = 234})
vim.api.nvim_set_hl(0, 'greenFGwhiteBG', {ctermfg = 0, ctermbg = 231})

vim.o.statusline="%#greenFGblackBG#%{get(b:, 'branch_name', '')} %h%m%r %=%F %=%{&encoding} %y %{&ff} %-8.(%l,%c%V%) %P"
vim.o.winbar="%#greenFGblackBG# %{winnr()} %f%m"
-- vim.o.tabline needs to iterate through tabs
