return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
  },
  keys = {
    { '<leader>s', function() require('telescope.builtin').find_files() end },
    { '<leader>S', function() require('telescope.builtin').buffers() end },
    { '<leader>gf', function() require('telescope.builtin').git_files() end },
    { '<leader>as', function() require('telescope.builtin').find_files({ cwd = require('telescope.utils').buffer_dir() }) end },
    { '<leader>aS', function() require('telescope.builtin').quickfix() end },
    { '<leader>al', function() require('telescope.builtin').find_files({ hidden = true, no_ignore = true, no_ignore_parent = true }) end },
    { '<leader>ag', function() require('telescope').extensions.live_grep_args.live_grep_args() end },
    { '<leader>aG', function() require('telescope.builtin').live_grep({ cwd = require('telescope.utils').buffer_dir() }) end },
    { '<leader>af', function() require('telescope.builtin').grep_string() end },
    { '<leader>aT', function() require('telescope.builtin').grep_string({ search = 'TODO' }) end },
    { '<leader>aF', function() require('telescope.builtin').current_buffer_fuzzy_find() end },
    { '<leader>aL', function() require('telescope.builtin').live_grep({ additional_args = { '--hidden' } }) end },
    { '<leader>aC', function() require('telescope.builtin').git_status() end },
    { '<leader>ac', function() require('telescope.builtin').git_commits() end },
    { '<leader>ab', function() require('telescope.builtin').git_branches() end },
    { '<leader>ah', function() require('telescope.builtin').help_tags() end },
  },
  config = function ()
    local actions = require('telescope.actions')
    local lga_actions = require('telescope-live-grep-args.actions')

    require('telescope').setup({
      defaults = {
        prompt_prefix = ' >',
        color_devicons = true,
        file_ignore_patterns = {
          '%.otf'
        },
        path_display = { shorten = { len = 1, exclude = { 1, 2, -1, -2 } } },

        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
          i = {
            ['<C-q>'] = actions.smart_add_to_qflist,
            ['<C-w>'] = actions.smart_send_to_qflist,
            ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
            ['<C-k>'] = actions.delete_buffer,
          },
          n = {
            ['<C-q>'] = actions.smart_add_to_qflist,
            ['<C-w>'] = actions.smart_send_to_qflist,
            ['<tab>'] = actions.toggle_selection,
            ['<C-k>'] = actions.delete_buffer,
          },
        },

        sorting_strategy = 'ascending',
        layout_strategy = 'horizontal',
        layout_config = {
          preview_width = 90,
          prompt_position = 'top',
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ['<C-k>'] = lga_actions.quote_prompt(),
              ['<C-j>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
              ['<C-q>'] = actions.smart_add_to_qflist,
              ['<C-w>'] = actions.smart_send_to_qflist,
              ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
            },
            n = {
              ['<C-q>'] = actions.smart_add_to_qflist,
              ['<C-w>'] = actions.smart_send_to_qflist,
              ['<tab>'] = actions.toggle_selection,
            },
          },
        }
      },
    })
    pcall(require('telescope').load_extension, 'fzf')
  end
}
