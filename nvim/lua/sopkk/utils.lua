local M = {}

M.last_cmd = {}
M.compile_window = nil
local close_compile_window = function()
  if M.compile_window and vim.api.nvim_win_is_valid(M.compile_window) then
    vim.api.nvim_win_close(M.compile_window, true)
  end
  M.compile_window = nil
end

function M.print_out(obj)
  vim.schedule(function() vim.cmd('checktime') end)
  print(obj.stdout)
  print(obj.stderr)
end

function M.run_async(args)
  local command = vim.fn.split(args.fargs[1], ' ')
  if command[1] == 'v:null' then
    command = vim.deepcopy(M.last_cmd)
  else
    M.last_cmd = vim.deepcopy(command)
  end

  if command[1] == '@' then
    table.remove(command, 1)
    vim.system(command, { text = true }, M.print_out) -- { timeout = N --ms }
    return
  elseif command[1] == '!' then
    table.remove(command,1)
    local shell_command = vim.fn.shellescape(table.concat(command, ' '))
    local pane_count = tonumber(vim.trim(vim.fn.system("tmux list-panes -F '#{pane_id}' | wc -l")))
    if not pane_count or pane_count < 1 then
      vim.notify("Error: Could not determine tmux pane count.")
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

  local original_window = vim.api.nvim_get_current_win()
  local compile_buffer = vim.api.nvim_create_buf(false, true)
  M.compile_window = vim.api.nvim_open_win(compile_buffer, true, {
    split = "below",
    win = -1,
    height = math.floor(vim.o.lines * 0.3),
    style = "minimal",
  })
  local actual_cwd = vim.fn.getcwd()
  vim.api.nvim_buf_set_lines(compile_buffer, -1, -1, false, { "> " .. table.concat(command, ' ') })

  vim.api.nvim_buf_set_keymap(compile_buffer, "n", "<CR>", "", {
    callback = function()
      local line = vim.api.nvim_get_current_line()

      local cfile = vim.fn.expand("<cfile>")
      local start_idx = line:find(cfile, 1, true)
      if not start_idx then
        print("Path not found on current line")
        return
      end
      local trimmed_line = line:sub(start_idx)

      -- Pipe into quickfix to take advantage of the errorformatting
      local original_qf_state = vim.fn.getqflist({ all = 0 })
      local original_efm = vim.go.errorformat

      local temp_efm = table.concat({
        '%f:%l:%c:%m',
        '%f:%l:%c',
        '%f:%l',
      }, ',')
      vim.go.errorformat = temp_efm .. ","  .. original_efm
      vim.fn.setqflist({}, 'r', { lines = { trimmed_line } })
      local qf_items = vim.fn.getqflist()

      vim.go.errorformat = original_efm
      vim.fn.setqflist({}, 'r', {
        items = original_qf_state.items,
        title = original_qf_state.title,
      })

      local lnum = qf_items[1].lnum
      local col = qf_items[1].col

      local full_path = vim.fs.normalize(vim.fs.joinpath(actual_cwd, cfile))
      if not vim.uv.factual_cwds_stat(full_path) and vim.uv.fs_stat(cfile) then
        full_path = vim.fs.normalize(cfile)
      end
      if not vim.uv.fs_stat(full_path) then
        return nil
      end

      if not vim.api.nvim_win_is_valid(original_window) then
        vim.notify("Original window is no longer valid", vim.log.levels.ERROR)
        return
      end

      local open_to_cmd = "edit +" .. lnum .. " " .. vim.fn.fnameescape(full_path)
      if type(col) == "number" and col > 0 then
        open_to_cmd = open_to_cmd .. " | normal! " .. col .. "|"
      end

      vim.fn.win_execute(original_window, open_to_cmd)
      vim.api.nvim_set_current_win(original_window)
    end,
    noremap = true,
    silent = true,
  })
  vim.api.nvim_buf_set_keymap(compile_buffer, "n", "q", "", {
    callback = function()
      close_compile_window()
    end,
    noremap = true,
    silent = true,
  })

  vim.api.nvim_buf_set_name(compile_buffer, "Run")
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = compile_buffer })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = compile_buffer })
  vim.api.nvim_set_option_value("swapfile", false, { buf = compile_buffer })
  vim.api.nvim_set_option_value("filetype", "compile", { buf = compile_buffer })

  local on_data = function(err, data)
    if err then
      vim.schedule(function()
        vim.api.nvim_buf_set_lines(compile_buffer, -1, -1, false, { "[Stream error: " .. err .. "]" })
      end)
      return
    end
    if data == nil then
      return
    end
    vim.schedule(function()
      local lines = vim.split(data, "\n", { trimempty = false })
      vim.api.nvim_buf_set_lines(compile_buffer, -1, -1, false, lines)
      local line_count = vim.api.nvim_buf_line_count(compile_buffer)
      if M.compile_window and vim.api.nvim_win_is_valid(M.compile_window) then
        vim.api.nvim_win_set_cursor(M.compile_window, {line_count, 0})
      end
    end)
  end

  local on_exit = function(obj)
    vim.schedule(function()
      local status_line = "[Command finished with code " .. obj.code .. "]"
      vim.api.nvim_buf_set_lines(compile_buffer, -1, -1, false, { "", status_line })
      local line_count = vim.api.nvim_buf_line_count(compile_buffer)
      vim.api.nvim_win_set_cursor(M.compile_window, {line_count, 0})
      vim.cmd('checktime')
    end)
  end

  vim.system(command, {
    text = true,
    stdout = on_data,
    stderr = on_data
  }, on_exit)

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = compile_buffer,
    once = true,
    callback = function()
      M.compile_window = nil
    end,
  })
  if vim.api.nvim_win_is_valid(original_window) then
    vim.api.nvim_set_current_win(original_window)
  end
end

return M
