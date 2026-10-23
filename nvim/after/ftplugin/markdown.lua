require('sopkk.wiki').setup_buffer()

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>WC', 'mx0f[lrx<Esc>`x', opts)
vim.keymap.set('n', '<leader>WD', 'mx0f[fxr<Space><Esc>`x', opts)
vim.keymap.set('n', '<leader>WE', 'mxI- [ ] <Esc>`x', opts)

local function sync_scroll(from_win, to_win, synced)
  if not (vim.api.nvim_win_is_valid(from_win) and vim.api.nvim_win_is_valid(to_win)) then
    return
  end
  local from_top = vim.fn.line("w0", from_win)
  if synced[from_win] == from_top then
    synced[from_win] = nil
    return
  end

  local from_lines = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(from_win))
  local to_lines = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(to_win))
  local top = math.max(1, math.floor((from_top - 1) / from_lines * to_lines) + 1)

  local height = vim.api.nvim_win_get_height(to_win)
  local so = math.min(vim.api.nvim_get_option_value("scrolloff", { win = to_win }), math.floor((height - 1) / 2))
  local min_lnum = top == 1 and 1 or top + so
  local max_lnum = math.max(min_lnum, top + height - 1 - so)
  local cursor = vim.api.nvim_win_get_cursor(to_win)[1]
  local lnum = math.min(math.max(cursor, min_lnum), max_lnum)

  local to_top = vim.fn.line("w0", to_win)
  vim.api.nvim_win_call(to_win, function()
    vim.fn.winrestview({ topline = top, lnum = lnum })
  end)
  local new_top = vim.fn.line("w0", to_win)
  if new_top ~= to_top then
    synced[to_win] = new_top
  end
end

local function preview_markdown_split()
  local src_buf = vim.api.nvim_get_current_buf()
  local file = vim.fn.expand("%:p")

  vim.cmd("tab split")
  local tab = vim.api.nvim_get_current_tabpage()
  vim.t[tab].markdown_preview_buf = src_buf
  vim.b[src_buf].markdown_preview_tab = tab
  local src_win = vim.api.nvim_get_current_win()
  vim.cmd("leftabove vsplit")
  local preview_win = vim.api.nvim_get_current_win()
  vim.wo[preview_win].number = false
  vim.wo[preview_win].relativenumber = false
  vim.wo[preview_win].signcolumn = "no"
  local synced = {}
  local rendering = false

  local function render()
    rendering = true
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    vim.api.nvim_win_set_buf(preview_win, buf)
    vim.keymap.set("n", "q", vim.cmd.tabclose, { buffer = buf })
    local width = vim.api.nvim_win_get_width(preview_win) - 2
    vim.api.nvim_win_call(preview_win, function()
      vim.fn.jobstart({ "leaf", "--inline", "ansi:" .. width, file }, {
        term = true,
        on_exit = function()
          vim.schedule(function()
            sync_scroll(src_win, preview_win, synced)
            rendering = false
          end)
        end,
      })
    end)
  end

  local group = vim.api.nvim_create_augroup("MarkdownPreviewSplit" .. src_win, { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", { group = group, buffer = src_buf, callback = render })
  vim.api.nvim_create_autocmd("WinScrolled", {
    group = group,
    pattern = tostring(src_win),
    callback = function() sync_scroll(src_win, preview_win, synced) end,
  })
  vim.api.nvim_create_autocmd("WinScrolled", {
    group = group,
    pattern = tostring(preview_win),
    callback = function()
      if not rendering then
        sync_scroll(preview_win, src_win, synced)
      end
    end,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = { tostring(src_win), tostring(preview_win) },
    callback = function() vim.api.nvim_del_augroup_by_id(group) end,
  })

  render()
end

local function toggle_markdown_preview()
  if vim.t.markdown_preview_buf then
    vim.cmd.tabclose()
    return
  end
  local tab = vim.b.markdown_preview_tab
  if tab and vim.api.nvim_tabpage_is_valid(tab) then
    vim.api.nvim_set_current_tabpage(tab)
    return
  end
  preview_markdown_split()
end

vim.keymap.set("n", "<leader>ms", toggle_markdown_preview)
