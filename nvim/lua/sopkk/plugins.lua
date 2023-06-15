local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-surround',
  'tpope/vim-commentary',
  'tpope/vim-repeat',

  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  'nvim-tree/nvim-web-devicons',

  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  'sindrets/diffview.nvim',

  'nvim-lualine/lualine.nvim',

  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  'jose-elias-alvarez/null-ls.nvim',

  'google/vim-jsonnet',

  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',

  'L3MON4D3/LuaSnip',

  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-fzy-native.nvim',
  'nvim-telescope/telescope-live-grep-args.nvim',

  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-context',

  'vimwiki/vimwiki',

  'ThePrimeagen/harpoon',

  'wuelnerdotexe/vim-enfocado',
  'folke/tokyonight.nvim',
  'bluz71/vim-nightfly-colors',
})
