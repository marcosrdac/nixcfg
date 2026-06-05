-- notes
--- available modifiers
--- - SUPER
--- - ALT
--- - CTRL
--- - SHIFT
-- helpers
--- formatters
local function cat_keys(s)
  return (s:gsub("%s*%+%s*", " + "):gsub("%s+", " + "))
end
local function shell_quote(cmd)
  return "'" .. cmd:gsub("'", [['"'"']]) .. "'"
end
local function cmd_to_sh(cmd)
  return "sh -c " .. shell_quote(cmd)
end
--- binders
local function bnd(k, dispatcher, opts)
  hl.bind(cat_keys(k), dispatcher, opts or {})
end
local function exe(k, cmd, opts)
  bnd(k, hl.dsp.exec_cmd(cmd), opts)
end
local function shl(k, cmd, opts)
  exe(k, cmd_to_sh(cmd), opts)
end
--- bind opts
local allow_repeat = { repeating = true }
local allow_locked = { locked = true }
local allow_repeat_locked = { repeating = true, locked = true }
-- end

--- focus/move workspace
for i = 1, 10 do
  local key = tostring(i % 10)
  bnd("ALT " .. key,       hl.dsp.focus({ workspace = i }))
  bnd("ALT SHIFT " .. key, hl.dsp.window.move({ workspace = i }))
end
--- focus window direction
bnd("ALT h", hl.dsp.focus({ direction = "l" }))
bnd("ALT j", hl.dsp.focus({ direction = "d" }))
bnd("ALT k", hl.dsp.focus({ direction = "u" }))
bnd("ALT l", hl.dsp.focus({ direction = "r" }))
--- next/prev window
bnd("ALT p", hl.dsp.window.cycle_next({ prev = true }))
bnd("ALT n", hl.dsp.window.cycle_next({ next = true }))
--- last window/workspace
bnd("SUPER tab", hl.dsp.focus({ last = true }))
bnd("ALT tab", hl.dsp.focus({ workspace = "previous" }))
-- tiled windows movement
bnd("ALT SHIFT h", hl.dsp.window.move({ direction = "l" }), allow_repeat)
bnd("ALT SHIFT j", hl.dsp.window.move({ direction = "d" }), allow_repeat)
bnd("ALT SHIFT k", hl.dsp.window.move({ direction = "u" }), allow_repeat)
bnd("ALT SHIFT l", hl.dsp.window.move({ direction = "r" }), allow_repeat)
-- TODO make a better window mover
-- floating window movement
bnd("SUPER h", hl.dsp.window.move({ x = -20, y = 0, relative = true }), allow_repeat)
bnd("SUPER j", hl.dsp.window.move({ x = 0, y = 20, relative = true }), allow_repeat)
bnd("SUPER k", hl.dsp.window.move({ x = 0, y = -20, relative = true }), allow_repeat)
bnd("SUPER l", hl.dsp.window.move({ x = 20, y = 0, relative = true }), allow_repeat)
-- TODO make a better resize script
-- local step = 20
-- local function resize_active(dx, dy)
--   hl.dispatch(hl.dsp.window.resize({
--     x = dx,
--     y = dy,
--     relative = true,
--   }))
-- end
-- local function resize_window(edge, amount)
--   if edge == "l" then
--     hl.dispatch(hl.dsp.focus({ direction = "l" }))
--     resize_active(-amount, 0)
--     hl.dispatch(hl.dsp.focus({ direction = "r" }))
--   elseif edge == "r" then
--     resize_active(amount, 0)
--   elseif edge == "t" then
--     hl.dispatch(hl.dsp.focus({ direction = "u" }))
--     resize_active(0, amount)
--     hl.dispatch(hl.dsp.focus({ direction = "d" }))
--   elseif edge == "b" then
--     resize_active(0, amount)
--   end
-- end

bnd("ALT SHIFT f", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
bnd("ALT f", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
bnd("ALT g", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

bnd("ALT t", hl.dsp.window.float({ action = "disable" }))
bnd("ALT SHIFT t", hl.dsp.window.pseudo({ action = "toggle" }))
bnd("ALT space", hl.dsp.window.float({ action = "toggle" }))

bnd("ALT m", hl.dsp.window.tag({
  tag = "marked",
}))
--

-- Apps
shl("ALT return", "$TERMINAL")
shl("ALT b", "$BROWSER")
exe("ALT o", "wofi --show drun")

-- Basic window actions
bnd("ALT SHIFT q", hl.dsp.window.close())
bnd("ALT CTRL SHIFT q", hl.dsp.window.close())
bnd("ALT SHIFT e", hl.dsp.exit())

bnd("ALT s", hl.dsp.window.pin())


-- Screenshots
shl("print", "grim - | wl-copy")
shl("SHIFT print", [[grim -g "$(slurp)" - | wl-copy]])

-- Media / brightness
exe("XF86AudioRaiseVolume", "pamixer -i 5", rl)
exe("XF86AudioLowerVolume", "pamixer -d 5", rl)
exe("XF86AudioMute", "pamixer --toggle-mute", l)

exe("XF86MonBrightnessUp", "brightnessctl set 5%+", rl)
exe("XF86MonBrightnessDown", "brightnessctl set 5%-", rl)

exe("XF86AudioPlay", "playerctl play-pause", l)
exe("XF86AudioNext", "playerctl next", l)
exe("XF86AudioPrev", "playerctl previous", l)
