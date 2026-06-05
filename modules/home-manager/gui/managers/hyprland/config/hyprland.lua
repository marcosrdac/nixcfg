HOME_DIR = os.getenv("HOME")
XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME") or (home_dir .. "/.config")
HYPR_DIR = XDG_CONFIG_HOME .. "/hypr"

require("utils")
require("env")
require("colors")
require("curves")
require("input")  -- TODO
require("rules")
require("start")
require("animations")
require("binds")
require("hm")

-- must work
hl.config({
  debug = {
    -- errors below
    error_position = 1,
    error_limit = 5,
  },
})

hl.bind("SUPER + Return", hl.dsp.exec_cmd("sh -c '$TERMINAL'"))

hl.config({
  general = {
    layout = "dwindle",
    border_size = 0,
    gaps_in = 10,
    gaps_out = 20,
  },

  decoration = {
    rounding = 1,
    dim_inactive = true,
    dim_strength = 0.15,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
  },

  dwindle = {
    preserve_split = true,
    split_width_multiplier = 0.6,
  },
})
