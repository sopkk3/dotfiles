local command = vim.cmd

local options = {
  completeopt = { 'menu', 'menuone', 'noselect' },
  encoding = 'utf-8',
  backup = false,
  writebackup = false,
  swapfile = false,
  mouse = '',

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

  scrolloff = 10,
  sidescrolloff = 5,
  cursorline = true,
  colorcolumn = '110',

  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  -- foldmethod = "expr", -- zx update folds in file. za toggle. zr open all, zm close all
  -- foldexpr = "nvim_treesitter#foldexpr()",
  -- foldlevel = 1,

  laststatus = 3,
}

vim.opt.wildignore:append('*/node_modules/*,*/target/*,*/.out,*/.git/*,*.swp')

vim.g.netrw_banner = 0

vim.g.jsonnet_fmt_on_save = 0

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- TBD: move to nvim function
command 'autocmd BufWritePre * %s/\\s\\+$//e' -- Deletes trailing whitespace on save
-- vim-commentary
command 'autocmd FileType c,cpp,cs,java        setlocal commentstring=//\\ %s'
command 'autocmd FileType sql                  setlocal commentstring=--\\ %s'
command 'autocmd FileType toml                 setlocal commentstring=#\\ %s'

vim.filetype.add({
  pattern = {
    ['.*Jenkinsfile.*'] = 'groovy'
  }
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")
