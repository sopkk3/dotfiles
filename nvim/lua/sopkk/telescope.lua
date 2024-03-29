if not pcall(require, 'telescope') then
  return
end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")
local extensions = require("telescope").extensions
local lga_actions = require("telescope-live-grep-args.actions")
require("telescope").setup({
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    prompt_prefix = " >",
    color_devicons = true,
    file_ignore_patterns = {
      "%.otf"
    },
    -- path_display = { truncate = 3 },
    path_display = { shorten = { len = 1, exclude = { 1, 2, -1, -2 } } },

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    mappings = {
      i = {
        ["<C-q>"] = actions.smart_add_to_qflist,
        ["<C-w>"] = actions.smart_send_to_qflist,
        ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
      },
      n = {
        ["<C-q>"] = actions.smart_add_to_qflist,
        ["<C-w>"] = actions.smart_send_to_qflist,
        ["<tab>"] = actions.toggle_selection,
      },
    },

    sorting_strategy = "ascending",
    layout_strategy = 'horizontal',
    layout_config = {
      preview_width = 90,
      prompt_position = "top",
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-j>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          ["<C-q>"] = actions.smart_add_to_qflist,
          ["<C-w>"] = actions.smart_send_to_qflist,
          ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        },
        n = {
          ["<C-q>"] = actions.smart_add_to_qflist,
          ["<C-w>"] = actions.smart_send_to_qflist,
          ["<tab>"] = actions.toggle_selection,
        },
      },
    }
  },
})

vim.keymap.set('n', '<leader>s', builtin.find_files)
vim.keymap.set('n', '<leader>S', builtin.buffers)
vim.keymap.set('n', '<leader>gf', builtin.git_files)
vim.keymap.set('n', '<leader>as', function()
  builtin.find_files({ cwd = utils.buffer_dir() })
end)
vim.keymap.set('n', '<leader>aS', builtin.quickfix)
vim.keymap.set('n', '<leader>ag', extensions.live_grep_args.live_grep_args)
vim.keymap.set('n', '<leader>aG', function()
  builtin.live_grep({ cwd = utils.buffer_dir() })
end)
vim.keymap.set('n', '<leader>af', builtin.grep_string)
vim.keymap.set('n', '<leader>at', function()
  builtin.grep_string({ search = "TODO"})
end)
vim.keymap.set('n', '<leader>aF', builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>aC', builtin.git_status)
vim.keymap.set('n', '<leader>ac', builtin.git_commits)
vim.keymap.set('n', '<leader>ab', builtin.git_branches)
vim.keymap.set('n', '<leader>ah', builtin.help_tags)
