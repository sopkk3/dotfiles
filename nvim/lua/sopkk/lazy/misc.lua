return {
  'mfussenegger/nvim-jdtls',
  'onsails/lspkind.nvim',
  'nvim-tree/nvim-web-devicons',
  {
    'stevearc/aerial.nvim',
    lazy = true,
    keys = {
      { "<leader>ao", "<cmd>AerialToggle!<CR>" }
    }
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', ft = { 'yaml' } },
  'lervag/wiki.vim',
  'nvim-lualine/lualine.nvim',
  {
    'williamboman/mason.nvim',
    opts = {
      PATH = 'append',
    },

  },

  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
  },
}
