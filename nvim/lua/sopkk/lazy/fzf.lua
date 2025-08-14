return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>s', function() require('fzf-lua').files({ git_icons = true }) end },
    { '<leader>S', function() require('fzf-lua').buffers() end },
    { '<leader>gf', function() require('fzf-lua').git_files() end },
    { '<leader>as', function() require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') }) end },
    { '<leader>aS', function() require('fzf-lua').quickfix() end },
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
        row = 1,
        width = 1,
        height = 0.7,
        border = { '', '─', '', '', '', '', '', '' },
        preview = {
          title = 'center',
          horizontal = 'right:55%',
          border = function(_, m)
            if m.type == 'fzf' then
              return 'single'
            else
              assert(m.type == 'nvim' and m.name == 'prev' and type(m.layout) == 'string')
              local b = { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
              if m.layout == 'down' then
                b[1] = '├' --top right
                b[3] = '┤' -- top left
              elseif m.layout == 'up' then
                b[7] = '├' -- bottom left
                b[6] = '' -- remove bottom
                b[5] = '┤' -- bottom right
              elseif m.layout == 'left' then
                b[3] = '┬' -- top right
                b[5] = '┴' -- bottom right
                b[6] = '' -- remove bottom
              else -- right
                b[1] = '┬' -- top left
                b[7] = '┴' -- bottom left
                b[6] = '' -- remove bottom
              end
              return b
            end
          end,
        },
      },
    })
  end
}
