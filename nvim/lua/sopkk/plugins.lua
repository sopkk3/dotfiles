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

  'google/vim-jsonnet',

  'hrsh7th/nvim-cmp',
  { 'hrsh7th/cmp-nvim-lsp', dependencies = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-nvim-lua', dependencies = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-buffer', dependencies = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-path', dependencies = { 'hrsh7th/nvim-cmp' } },
  { 'saadparwaiz1/cmp_luasnip', dependencies = { 'L3MON4D3/LuaSnip' } },

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
})
