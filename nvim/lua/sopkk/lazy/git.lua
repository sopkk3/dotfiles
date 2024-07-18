return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>G', function()
        local fugitive_buf_no = vim.fn.bufnr('^fugitive:')
        local buf_win_id = vim.fn.bufwinid(fugitive_buf_no)
        if fugitive_buf_no >= 0 and buf_win_id >= 0 then
          vim.api.nvim_win_close(buf_win_id, false)
        else
          vim.cmd(":G")
        end
      end },
      { '<leader>gb', '<cmd>G blame<CR>' },
      { '<leader>gp', '<cmd>G push<CR>' },
      { '<leader>gl', '<cmd>G pull<CR>' },
      { '<leader>gb', '<cmd>G blame<CR>' },
    },
  },
  {
    'sindrets/diffview.nvim',
    keys = {
      { '<leader>gd', ':DiffviewOpen ' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = {text = '│'},
          change       = {text = '│'},
          delete       = {text = '_'},
          topdelete    = {text = '‾'},
          changedelete = {text = '~'},
        },
        signcolumn = false,
        numhl      = true,
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 10000,
      })
    end,
  },
}
