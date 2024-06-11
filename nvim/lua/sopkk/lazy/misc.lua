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
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require("oil").setup()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },

}
