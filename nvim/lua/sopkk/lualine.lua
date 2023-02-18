if not pcall(require, 'lualine') then
  return
end

local trailing = {
  function()
    local s = vim.fn.search('\\s$', 'nw')
    if s > 0 then
      return "[" ..s.. "] trailing"
    else
      return ""
    end
  end,
  color = { bg = 'DarkOrange' },
}

local mixedIndent = {
  function()
    local l = vim.fn.search('\\v(^\\t+ +)|(^ +\\t+)', 'nw')
    if l > 0 then
      return "[" ..l.. "] mixed-indent"
    else
      return ""
    end
  end,
  color = { bg = 'DarkOrange' },
}

local mixedIndentFile = {
  function()
    local t = vim.fn.search('\\v(^\\t+)', 'nw')
    local s = vim.fn.search('\\v(^ +)', 'nw')
    if t > 0 and s > 0 then
      return "[" ..t..":"..s.. "] mixed-indent-file"
    else
      return ""
    end
  end,
  color = { bg = 'DarkOrange' },
}

local function window()
  return vim.api.nvim_win_get_number(0)
end

local colors = {
  black        = '#202020', dim_black    = '#2e2d2d',
  neon         = '#DFFF00', white        = '#FFFFFF',
  green        = '#00D700', purple       = '#5F005F',
  blue         = '#00DFFF', darkblue     = '#00005F',
  navyblue     = '#000080', brightgreen  = '#9CFFD3',
  gray         = '#444444', darkgray     = '#3c3836',
  lightgray    = '#504945', inactivegray = '#7c6f64',
  orange       = '#FFAF00', red          = '#5F0000',
  brightorange = '#C08A20', brightred    = '#AF0000',
  cyan         = '#00DFFF',
}

-- based on powerline_dark
local sopkk_theme = {
  normal = {
    a = { bg = colors.neon, fg = colors.black, gui = 'bold' },
    b = { bg = colors.gray, fg = colors.white },
    c = { bg = colors.black, fg = colors.brightgreen },
  },
  insert = {
    a = { bg = colors.blue, fg = colors.darkblue, gui = 'bold' },
    b = { bg = colors.navyblue, fg = colors.white },
    c = { bg = colors.purple, fg = colors.white },
  },
  visual = {
    a = { bg = colors.orange, fg = colors.black, gui = 'bold' },
    b = { bg = colors.darkgray, fg = colors.white },
    c = { bg = colors.red, fg = colors.white },
  },
  replace = {
    a = { bg = colors.brightred, fg = colors.white, gui = 'bold' },
    b = { bg = colors.cyan, fg = colors.darkblue },
    c = { bg = colors.navyblue, fg = colors.white },
  },
  command = {
    a = { bg = colors.green, fg = colors.black, gui = 'bold' },
    b = { bg = colors.darkgray, fg = colors.white },
    c = { bg = colors.black, fg = colors.brightgreen },
  },
  inactive = {
    a = { bg = colors.darkgray, fg = colors.gray, gui = 'bold' },
    b = { bg = colors.darkgray, fg = colors.gray },
    c = { bg = colors.black, fg = colors.brightgreen },
  },
}


require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = sopkk_theme,
    -- theme = 'onedark',
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_c = {'%r %=%F %m'},
    lualine_x = {'encoding', 'filetype'},
    lualine_z = {'location', trailing, mixedIndent, mixedIndentFile}
  },
  tabline = {
    -- lualine_a = {{'tabs', mode = 2}},
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {window, 'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_c = {window, '%F %m'},
  }
}
