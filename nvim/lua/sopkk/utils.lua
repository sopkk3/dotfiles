local M = {}

function  M.print_out(obj)
  print(obj.stdout)
  print(obj.stderr)
end

function M.run_async(args)
  local command = vim.fn.split(args.fargs[1], ' ')

  if command[1] == '!' then
    table.remove(command, 1)
    local shell_command = vim.fn.shellescape(table.concat(command, ' '))
    local prev_win = vim.api.nvim_get_current_win()
    vim.cmd("below split | terminal " .. shell_command)
    vim.cmd("normal G")
    local height = math.floor(0.3 * vim.o.lines)
    vim.cmd("resize " .. height)
    if vim.api.nvim_win_is_valid(prev_win) then
      vim.api.nvim_set_current_win(prev_win)
    end
    return
  elseif command[1] == '@' then
    table.remove(command,1)
    local shell_command = vim.fn.shellescape(table.concat(command, ' '))
    local pane_count = tonumber(vim.trim(vim.fn.system("tmux list-panes -F '#{pane_id}' | wc -l")))
    if not pane_count or pane_count < 1 then
      print("Error: Could not determine tmux pane count.")
      return
    end
    if pane_count == 1 then
      vim.fn.system("tmux split-window -c " .. vim.fn.shellescape(vim.fn.getcwd()))
      local new_pane_id = vim.trim(vim.fn.system("tmux display-message -p '#{pane_id}'"))
      vim.fn.system("tmux send-keys -t " .. new_pane_id .. " " .. shell_command .. " C-m")
    else
      vim.fn.system("tmux send-keys -t :.- " .. shell_command .. " C-m")
      vim.fn.system("tmux select-pane -t :.-")
    end
    return
  end

  vim.system(command, { text = true }, M.print_out) -- { timeout = N --ms }
end

return M
