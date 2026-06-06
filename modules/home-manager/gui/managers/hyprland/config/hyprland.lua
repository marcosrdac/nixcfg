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
  },
  dwindle = {
    force_split                  = 2,
    smart_split                  = false,
    preserve_split               = true,
    smart_resizing               = false,
    use_active_for_splits        = true,
    permanent_direction_override = false,
    precise_mouse_move           = false,
    default_split_ratio          = 1.2,
    -- split_bias                   = 1,
    -- special_scale_factor         = 1,
    -- split_width_multiplier       = 2.0,
  },
})

hl.config({
  general = {
    border_size = 0,
    gaps_in = 10,
    gaps_out = 20,
  },
  decoration = {
    rounding = 5,
    rounding_power = 3,
  },
})

hl.config({
  decoration = {
    blur = {
      special = false,
    },
    dim_special = .15,
  },
})

hl.config({
  decoration = {
    blur = {
      enabled = true,
      ignore_opacity = true,
      size = 11,
      passes = 3,
      xray = false,
      -- noise = 0.01,
      new_optimizations = true,
      brightness = 0.7,
      contrast = .7,
      -- vibrancy = 0.17,
      -- vibrancy_darkness = 0.17,
      -- input_methods = false,
      -- input_methods_ignorealpha = false,
      popups = true,
      popups_ignorealpha = .2,
    },
  },
})

hl.config({
  misc = {
    disable_hyprland_logo = false,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
  },
})

hl.config({
  decoration = {
    active_opacity = 1.0,
    inactive_opacity = 0.9,
    fullscreen_opacity = 0.9,
    dim_inactive = true,
    dim_strength = 0.05,
    -- dim_modal = false,
    -- dim_around = 100,
    -- border_part_of_window = false,  -- ?
    screen_shader = "",
  },
})


hl.config({
  decoration = {
    glow = {
      enabled = false,
      range = 3,
      render_power = 3,
      color = "rgba(1a1a1aee)",
      color_inactive = "rgba(1a1a1aee)",
    },
    shadow = {
      enabled = true,
      sharp = false,
      range = 3,
      render_power = 3,
      offset = { 0, 0 },
      color = "rgba(00000055)",
      color_inactive = "rgba(00000022)",
      scale = 1.0,
    },
  },
})

-- # TODO
hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@144",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "2560x1080@74.99",
  position = "1921x0",
  scale = 1,
})
