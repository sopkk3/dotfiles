vim.opt_local.commentstring = [[# %s]]

local function apply_folds()
  vim.opt_local.foldmethod = 'marker'
  vim.opt_local.foldmarker = '-- {{,-- }}'
  vim.opt_local.foldlevel = 0
end

apply_folds()

vim.api.nvim_create_autocmd('BufWinEnter', {
  buffer = 0,
  callback = apply_folds,
})
