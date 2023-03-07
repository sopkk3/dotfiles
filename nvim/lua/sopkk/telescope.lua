if not pcall(require, 'telescope') then
  return
end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")
require("telescope").setup({
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    sorting_strategy = 'ascending',
    prompt_prefix = " >",
    color_devicons = true,

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist,
        ["<C-w>"] = actions.send_selected_to_qflist,
        ["<tab>"] = actions.toggle_selection + actions.move_selection_previous,
      },
      n = {
        ["<C-q>"] = actions.send_to_qflist,
        ["<C-w>"] = actions.send_selected_to_qflist,
        ["<tab>"] = actions.toggle_selection,
      },
    },

    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'top',
      preview_width = 90,
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
})

vim.keymap.set('n', '<leader>s', builtin.find_files)
vim.keymap.set('n', '<leader>S', builtin.git_files)
vim.keymap.set('n', '<leader>as', function()
  builtin.find_files({cwd = utils.buffer_dir()})
end)
vim.keymap.set('n', '<leader>aS', builtin.buffers)
vim.keymap.set('n', '<leader>ag', builtin.live_grep)
vim.keymap.set('n', '<leader>aG', function()
  builtin.live_grep({cwd = utils.buffer_dir()})
end)
vim.keymap.set('n', '<leader>af', builtin.grep_string)
vim.keymap.set('n', '<leader>aF', builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>aC', builtin.git_status)
vim.keymap.set('n', '<leader>ac', builtin.git_commits)
vim.keymap.set('n', '<leader>ab', builtin.git_branches)
vim.keymap.set('n', '<leader>gr', builtin.lsp_references)
