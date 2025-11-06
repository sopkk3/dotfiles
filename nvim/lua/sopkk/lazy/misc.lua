return {
  'mfussenegger/nvim-jdtls',
  'onsails/lspkind.nvim',
  'nvim-tree/nvim-web-devicons',
  {
    'stevearc/aerial.nvim',
    lazy = true,
    keys = {
      { "<leader>ao", "<cmd>AerialToggle!<CR>" }
    },
    config = function ()
      require('aerial').setup()
    end
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', ft = { 'yaml' } },
  'lervag/wiki.vim',
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
      require("oil").setup({
        default_file_explorer = false,
        view_options = {
          show_hidden = true,
        }
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },
  {
    'echasnovski/mini.hipatterns',
    config = function ()
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          todo  = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsNote' },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end
  },
  {
    "j-hui/fidget.nvim",
    opts = { },
  }

}
