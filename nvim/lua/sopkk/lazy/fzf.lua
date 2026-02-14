return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>s', function() require('fzf-lua').files({ git_icons = true }) end },
    { '<leader>S', function() require('fzf-lua').buffers() end },
    { '<leader>gf', function() require('fzf-lua').git_files() end },
    { '<leader>as', function() require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') }) end },
    { '<leader>cs', function() require('fzf-lua').quickfix() end },
    { '<leader>ag', function() require('fzf-lua').live_grep() end },
    { '<leader>aG', function() require('fzf-lua').live_grep({ search_paths = vim.fn.expand('%:p:h') }) end },
    { '<leader>af', function() require('fzf-lua').grep_cword() end },
    { '<leader>aF', function() require('fzf-lua').grep_curbuf() end },
    { '<leader>aT', function() require('fzf-lua').grep({ search = 'TODO' }) end },
    { '<leader>aC', function() require('fzf-lua').git_status() end },
    { '<leader>ac', function() require('fzf-lua').git_commits() end },
    { '<leader>ab', function() require('fzf-lua').git_branches() end },
    { '<leader>ah', function() require('fzf-lua').helptags() end },
  },
  config = function ()
    local actions = require('fzf-lua').actions
    require('fzf-lua').setup({
      fzf_opts = {
        ['--cycle'] = true
      },
      files = {
        cwd_prompt = false,
        no_header = true,
        formatter = 'path.dirname_first',
        actions = {
          ['alt-i'] = { actions.toggle_ignore },
          ['alt-h'] = { actions.toggle_hidden },
        },
      },
      grep = {
        rg_glob = true,
        glob_flag = '--iglob',
        no_header = true,
        actions = {
          ['alt-i'] = { actions.toggle_ignore },
          ['alt-h'] = { actions.toggle_hidden },
        },
      },
      buffers = {
        actions = {
          ['ctrl-k'] = { fn = actions.buf_del, reload = true }
        },
      },
      git = {
        branches = {
          cmd_del  = { "git", "branch", "--delete", "--force" },
        },
      },
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 300,
        },
      },
      keymap = {
        fzf = {
          ['ctrl-q'] = "select-all+accept",
        }
      },
      winopts = {
        split = "belowright " .. math.floor(vim.o.lines * 0.45) .. "new",
        on_create = function()
          vim.wo.winbar = " "
        end,

        border = "none",
        preview = {
          layout = "horizontal",
          horizontal = "right:50%",
        },
      },
    })
  end
}
