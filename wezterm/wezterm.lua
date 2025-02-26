local wezterm = require 'wezterm';

local config = {}

config.font = wezterm.font('Cousine Nerd Font Mono')

config.hide_tab_bar_if_only_one_tab = true

if wezterm.target_triple:find("windows") ~= nil then
  config.font_size = 11.0
  config.wsl_domains = {
    {
      name = "WSL:Ubuntu",
      distribution = "Ubuntu"
    }
  }
  config.default_domain = "WSL:Ubuntu"
elseif wezterm.target_triple:find("darwin") ~= nil then
  config.font_size = 13.0
end

config.colors = {
  foreground = 'white',
  background = '#1c1c1c',

  cursor_fg = 'black',
  cursor_bg = '#fff000',

  ansi = {
    '#000000',
    '#8a2f58',
    '#287373',
    '#914e89',
    '#395573',
    '#5e468c',
    '#2b7694',
    '#899ca1',
  },
  brights = {
    '#3d3d3d',
    '#cf4f88',
    '#53a6a6',
    '#bf85cc',
    '#4779b3',
    '#7f62b3',
    '#47959e',
    '#c0c0c0',
  },
}

return config
