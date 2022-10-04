if not pcall(require, 'telescope') then
  return
end

local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
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
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
})

vim.keymap.set('n', '<leader>s', "<cmd>lua require('telescope.builtin').find_files()<CR>")
vim.keymap.set('n', '<leader>S', "<cmd>lua require('telescope.builtin').git_files()<CR>")
vim.keymap.set('n', '<leader>as', "<cmd>lua require('telescope.builtin').find_files({cwd = require('telescope.utils').buffer_dir()})<CR>")
vim.keymap.set('n', '<leader>aS', "<cmd>lua require('telescope.builtin').buffers()<CR>")
vim.keymap.set('n', '<leader>ag', "<cmd>lua require('telescope.builtin').live_grep()<CR>")
vim.keymap.set('n', '<leader>aG', "<cmd>lua require('telescope.builtin').live_grep{cwd = require('telescope.utils').buffer_dir()}<CR>")
vim.keymap.set('n', '<leader>af', "<cmd>lua require('telescope.builtin').grep_string()<CR>")
vim.keymap.set('n', '<leader>aF', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
vim.keymap.set('n', '<leader>aC', "<cmd>lua require('telescope.builtin').git_status()<CR>")
vim.keymap.set('n', '<leader>ac', "<cmd>lua require('telescope.builtin').git_commits()<CR>")
vim.keymap.set('n', '<leader>ab', "<cmd>lua require('telescope.builtin').git_branches()<CR>")
