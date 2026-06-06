hl.config({
  input = {
    -- keyboard
    kb_layout = "us",
    kb_variant = "intl",
    kb_options = "caps:swapescape",
    -- mouse
    sensitivity = 0.0,
    -- delay
    repeat_delay = 550,
    -- lock
    numlock_by_default = true,
    tablet = {
      -- tablet
      output = "current",
      transform = 0,
      -- 0 -> normal
      -- 1 -> 90 degrees
      -- 2 -> 180 degrees
      -- 3 -> 270 degrees
      -- 4 -> flipped
      -- 5 -> flipped + 90 degrees
      -- 6 -> flipped + 180 degrees
      -- 7 -> flipped + 270 degrees
    },
  },
})

hl.config({
  input = {
    touchpad = {
      natural_scroll = false,
      tap_to_click = true,
    },
  }
})

hl.config({
  input = {
    follow_mouse = 2,
    float_switch_override_focus = 0,
  },
})
