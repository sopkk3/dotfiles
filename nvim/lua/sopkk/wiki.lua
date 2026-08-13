local M = {}

local WIKI_LINK = '%[%[(.-)%]%]'
local MD_LINK = '%[.-%]%((.-)%)'

-- \[\[..\]\]  or  \[..\](..)
local LINK_SEARCH = '\\%(\\[\\[.\\{-}\\]\\]\\|\\[.\\{-}\\](.\\{-})\\)'

local position_stack = {}

local function find_target_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  for _, pattern in ipairs({ WIKI_LINK, MD_LINK }) do
    local from = 1
    while true do
      local s, e, target = line:find(pattern, from)
      if not s then break end
      if col >= s and col <= e then
        return (target:gsub('|.*$', ''))
      end
      from = e + 1
    end
  end
end

local function slugify(text)
  return text:lower():gsub('%s+', '-'):gsub('[^%w%-]', '')
end

local function jump_to_anchor(anchor)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    local _, header = line:match('^(#+)%s*([^#].*)$')
    if header and slugify(header:gsub('%s+$', '')) == anchor then
      vim.api.nvim_win_set_cursor(0, { i, 0 })
      return
    end
  end
end

local function resolve_path(path)
  if path == '' then return vim.api.nvim_buf_get_name(0) end

  local dir = vim.fn.expand('%:p:h')
  local full = dir .. '/' .. path
  if full:match('%.md$') then return full end
  return full .. '.md'
end

function M.follow_link()
  local target = find_target_at_cursor()
  if not target then return end

  if target:match('^%a[%w+.-]*://') or target:match('^mailto:') then
    vim.ui.open(target)
    return
  end

  table.insert(position_stack, {
    file = vim.api.nvim_buf_get_name(0),
    cursor = vim.api.nvim_win_get_cursor(0),
  })

  local anchor = target:match('^#(.+)$')
  if anchor then
    jump_to_anchor(anchor)
    return
  end

  local resolved = resolve_path(target)
  local dir = vim.fn.fnamemodify(resolved, ':h')
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
  vim.cmd('edit ' .. vim.fn.fnameescape(resolved))
end

function M.next_link()
  vim.fn.search(LINK_SEARCH, 's')
end

function M.prev_link()
  vim.fn.search(LINK_SEARCH, 'sb')
end

function M.return_link()
  local previous = table.remove(position_stack)
  if not previous then return end

  if previous.file ~= vim.api.nvim_buf_get_name(0) then
    vim.cmd('edit ' .. vim.fn.fnameescape(previous.file))
  end
  vim.api.nvim_win_set_cursor(0, previous.cursor)
end

local TOC_TITLE = '*Contents*'
local TOC_DEPTH = 6

local function gather_headers()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local headers = {}
  local in_code = false

  for _, line in ipairs(lines) do
    if line:match('^%s*```') then
      in_code = not in_code
    elseif not in_code then
      local hashes, text = line:match('^(#+)%s*([^#].*)$')
      if hashes then
        text = text:gsub('%s+$', '')
        table.insert(headers, {
          level = #hashes,
          header = text,
          anchor = '#' .. slugify(text),
        })
      end
    end
  end

  return headers
end

local function find_existing_toc()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    if line == TOC_TITLE then
      local last = i
      local j = i + 1
      if lines[j] and lines[j]:match('^%s*$') then
        last = j
        j = j + 1
      end
      while lines[j] and lines[j]:match('^%s*[*-] ') do
        last = j
        j = j + 1
      end
      return i, last
    end
  end
  return nil
end

function M.toc_generate()
  local headers = gather_headers()
  if #headers == 0 then return end

  local rendered = { TOC_TITLE }
  for _, h in ipairs(headers) do
    if h.level <= TOC_DEPTH then
      local indent = string.rep(' ', vim.bo.shiftwidth * (h.level - 1))
      table.insert(rendered, indent .. '* [' .. h.header .. '](' .. h.anchor .. ')')
    end
  end
  table.insert(rendered, '')

  local start_line, end_line = find_existing_toc()
  if start_line and end_line then
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, rendered)
  else
    vim.api.nvim_buf_set_lines(0, 0, 0, false, rendered)
  end
end

function M.setup_buffer()
  local opts = { buffer = true, silent = true }
  vim.keymap.set('n', '<CR>', M.follow_link, opts)
  vim.keymap.set('n', '<BS>', M.return_link, opts)
  vim.keymap.set('n', '<Tab>', M.next_link, opts)
  vim.keymap.set('n', '<S-Tab>', M.prev_link, opts)
  vim.api.nvim_buf_create_user_command(0, 'TocGenerate', M.toc_generate, {})
end

return M
