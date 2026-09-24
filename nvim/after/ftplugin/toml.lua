vim.opt_local.commentstring = [[# %s]]

local function apply_folds()
  vim.opt_local.foldmethod = 'marker'
  vim.opt_local.foldmarker = '-- {{,-- }}'
end

vim.opt_local.foldlevel = 0
apply_folds()

vim.api.nvim_create_autocmd('BufWinEnter', {
  buffer = 0,
  callback = apply_folds,
})
