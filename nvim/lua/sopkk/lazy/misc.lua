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
  { 'lervag/wiki.vim',
    keys = {
      { '<leader>WC', 'mx0f[ax<Esc>`x' }, -- check [] box
      { '<leader>WD', 'mx0f[fxx<Esc>`x' }, -- uncheck [x] box
    }
  },
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
