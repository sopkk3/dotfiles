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

  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'kristijanhusak/vim-dadbod-completion',
}
