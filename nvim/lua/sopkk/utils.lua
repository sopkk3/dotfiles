local M = {}

function  M.print_out(obj)
  print(obj.stdout)
  print(obj.stderr)
end

function M.run_async(args)
  local command = vim.fn.split(args.fargs[1], ' ')
  if command[1] == '!' then
    table.remove(command, 1)
    local shell_command = table.concat(command, ' ')
    local prev_win = vim.api.nvim_get_current_win()
    vim.cmd("below split | terminal " .. shell_command)
    vim.cmd("normal G")
    local height = math.floor(0.3 * vim.o.lines)
    vim.cmd("resize " .. height)
    if vim.api.nvim_win_is_valid(prev_win) then
      vim.api.nvim_set_current_win(prev_win)
    end
    return
  end

  vim.system(command, { text = true }, M.print_out) -- { timeout = N --ms }
end

return M
