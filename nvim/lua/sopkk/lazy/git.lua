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
      { '<leader>gd', '<cmd>DiffviewOpen ' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
          change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
          delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        },
        signcolumn = false,
        numhl      = true,
        linehl     = false,
        word_diff  = false,
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
        max_file_length = 40000,
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        yadm = {
          enable = false
        },
      })
    end,
  },
}
