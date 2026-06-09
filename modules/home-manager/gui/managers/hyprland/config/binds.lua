-- TODO bspwm diff s6a2622d6-2e60-83e9-8a30-dedaac7391b0
local json = require("utils/json")
local str = require("utils/str")
local B = require("utils.bindings")
local cmd, exe, shl, seq = B.cmd, B.exe, B.shl, B.seq
local d = hl.dsp
local focus, win, ws, monitor = d.focus, d.window, d.workspace, d.monitor
local ws_rule = hl.workspace_rule


-- mouse
cmd("ALT mouse:272", win.drag(), "MOUSE")
cmd("ALT mouse:273", win.resize(), "MOUSE")
-- close
cmd("     ALT SHIFT q", hl.dsp.window.close())
cmd("CTRL ALT SHIFT q", hl.dsp.window.kill())
cmd("     ALT SHIFT e", hl.dsp.exit())
-- focus/move
-- workspace focus/move
for i = 1, 10 do
  local key = tostring(i % 10)
  ws_rule({ workspace = i, persistent = true })
  cmd("ALT       " .. key, focus({ workspace = i }))
  cmd("ALT SHIFT " .. key, win.move({ workspace = i; follow = false }))
end
-- window focus
cmd("ALT h", focus({ direction = "l" }))
cmd("ALT j", focus({ direction = "d" }))
cmd("ALT k", focus({ direction = "u" }))
cmd("ALT l", focus({ direction = "r" }))
--- next/prev
cmd("ALT p", win.cycle_next({ next = false }))
cmd("ALT n", win.cycle_next({ next = true }))
--- last window/workspace
-- cmd("SUPER tab", focus({ last = true }))
-- cmd("ALT   tab", focus({ workspace = "previous" }))  -- BELOW
-- tiled windows movement
shl("ALT SHIFT H", [[ win-move-or-group.sh l ]], "HOLDS")
shl("ALT SHIFT J", [[ win-move-or-group.sh d ]], "HOLDS")
shl("ALT SHIFT K", [[ win-move-or-group.sh u ]], "HOLDS")
shl("ALT SHIFT L", [[ win-move-or-group.sh r ]], "HOLDS")
-- TODO make a better window mover
-- floating window movement
cmd("SUPER h", win.move({ x = -20, y = 0, relative = true }), "HOLDS")
cmd("SUPER j", win.move({ x = 0, y = 20, relative = true }), "HOLDS")
cmd("SUPER k", win.move({ x = 0, y = -20, relative = true }), "HOLDS")
cmd("SUPER l", win.move({ x = 20, y = 0, relative = true }), "HOLDS")
--  window resizing
cmd("CTRL ALT h", win.resize({ x = -20, y = 0, relative = true }), "HOLDS")
cmd("CTRL ALT j", win.resize({ x = 0, y = 20, relative = true }), "HOLDS")
cmd("CTRL ALT k", win.resize({ x = 0, y = -20, relative = true }), "HOLDS")
cmd("CTRL ALT l", win.resize({ x = 20, y = 0, relative = true }), "HOLDS")
-- modes
cmd("ALT       space", win.float({ action = "toggle" }))
cmd("ALT SHIFT space", win.pseudo({ action = "toggle" }))  -- not as used as I want it to be
-- esse aqui mantem os gaps (todo fullscreen de uma janela só deve ser FULLSCREEN MESMO)
cmd("ALT f", win.fullscreen({ mode = "maximized", action = "toggle" }))
cmd("ALT g", win.fullscreen({ mode = "fullscreen", action = "toggle" }))
-- cmd("ALT s", hl.dsp.window.pin())
-- groups
shl("     ALT       t", [[ group-or-remove-from-group.sh normal ]])
shl("     ALT SHIFT t", [[ group-or-remove.sh toggle-out ]])
cmd("CTRL ALT SHIFT t", d.group.lock("toggle"))
---- cycle ws | cycle grouped windows
shl("     ALT       tab", [[ ws-or-tab-cycle.sh f ]], "HOLDS")
shl("     ALT SHIFT tab", [[ ws-or-tab-cycle.sh b ]], "HOLDS")
shl("CTRL ALT       tab", [[ tab-move.sh f ]], "HOLDS")
shl("CTRL ALT SHIFT tab", [[ tab-move.sh b ]], "HOLDS")


-- Screenshots
shl("      print", [[ grim - | wl-copy ]])
shl("SHIFT print", [[ grim -g "$(slurp)" - | wl-copy ]])

-- audio
exe("XF86AudioMute",                              "pamixer --toggle-mute", safe)
exe({ "XF86AudioRaiseVolume", "ALT SHIFT up" },   "pamixer -i 5", "SAFE:HOLDS")
exe({ "XF86AudioLowerVolume", "ALT SHIFT down" }, "pamixer -d 5", "SAFE:HOLDS")
-- brightness
exe({"XF86MonBrightnessUp", "ALT SHIFT right"},  "brightnessctl set 5%+", "SAFE:HOLDS")
exe({"XF86MonBrightnessDown", "ALT SHIFT left"}, "brightnessctl set 5%-", "SAFE:HOLDS")

exe("XF86AudioPlay", "playerctl play-pause", safe)
exe("XF86AudioNext", "playerctl next", safe)
exe("XF86AudioPrev", "playerctl previous", safe)


--DEFAULT_KEYS = {
--  -- letters
--  "a","b","c","d","e","f","g","h","i","j","k","l","m",
--  "n","o","p","q","r","s","t","u","v","w","x","y","z",
--  -- number row
--  "0","1","2","3","4","5","6","7","8","9","minus","equal",
--  -- punctuation
--  "bracketleft","bracketright","backslash",
--  "semicolon","comma","period","slash",
--  -- movement
--  "left","right","up","down",
--  "home","end","page_up","page_down",
--  -- system
--  "space","return","tab",
--  "backspace","delete",
--  "print",
--  "escape",
--  -- function keys
--  "F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12",
--}

-- special workspaces
--- calculator
cmd("ALT       c", ws.toggle_special("calculator"))
cmd("ALT SHIFT c", win.move({ workspace = "special:calculator"; follow = false }))
hl.workspace_rule({
  workspace = "special:calculator",
  on_created_empty = [[
    $TERMINAL --class julia-calculator -e julia --startup-file=no --quiet -i -e '
      atreplinit() do repl
        REPL = Base.invokelatest(Base.require, Main, :REPL)
        if !isdefined(repl, :interface)
          repl.interface = Base.invokelatest(REPL.setup_interface, repl)
        end
        repl.interface.modes[1].prompt = "> "
      end
  ']],
})
hl.window_rule({
  match = { class = "julia-calculator" },
  float = true,
  size = { 600, 400 },
  center = true,
})
--- hidden
cmd("ALT SHIFT z", win.move({ workspace = "special:hidden"; follow = false }))
cmd("ALT       z", ws.toggle_special("hidden"))
shl("mouse:275", [[ hide-special-ws.sh hidden ]])
shl("mouse:276", [[ hide-special-ws.sh hidden ]])
-- end special workspaces

-- tagging
cmd("ALT m", win.tag({ tag = "marked" }))
hl.window_rule({
  match = { tag = "marked" },
  border_color = "rgb(ffffff) rgb(ffffff)",
  border_size = 3,
})
-- tagging end


-- calls
shl("ALT return", [[ $TERMINAL ]])
exe("ALT b     ", [[ $BROWSER ]])
exe("ALT o     ", [[ wofi --show drun ]])
-- sequences
-- ! TODO add swallow and on_invalid=notify
-- ! add sxhkd syntax:
--alt + v : alt + {h,j,k,l,Tab}
--  bspc node -f @{west,south,north,east,brother}
--- window open
seq("ALT w", {
  ["      b"] = [[ $BROWSER ]],
  ["SHIFT b"] = [[ $ALTBROWSER ]],
  ["      h"] = [[ $TERMINAL -e btop ]],
  ["      n"] = [[ $TERMINAL -e $FILEBROWSER ]],
  ["SHIFT n"] = [[ thunar ]],  -- change to ALTFILEBROWSER/GUIFILEBROWSER
  -- ["      j"] = [[ $TERMINAL -e $EDITOR ]], -- JOURNAL!
  -- ["      w"] = [[ $TERMINAL -e $EDITOR ... ]]-- notes wiki (vimwiki)
  -- ["      s"] = [[ $TERMINAL -e $SPOTIFY_NCURSES_LIKE ]],
  -- ["SHIFT s"] = [[ $TERMINAL -e $SPOTIFY_GUI ]],
  ["g"] = [[ gimp ]],
  ["i"] = [[ inkscape ]],

  ["      a"] = [[ arandr ]],
  -- ["SHIFT a"] = [[ TODO automated menu ]],  -- kpmenu like vault app

  --["      k"] = [[ kpmenu_wal ]],  -- kpmenu like vault app
  --["SHIFT k"] = [[ bitwarden_gui ]],  -- GUI vault app
})
--- edit file
seq("ALT e", {
  h = [[ $TERMINAL --working-directory $XDG_CONFIG_HOME/hypr -e $EDITOR $XDG_CONFIG_HOME/hypr/binds.lua ]],
})
--- execute script
seq("ALT x", {
  x = [[ notify-win-state.sh ]],
  d = [[ hours.sh ]],
})


-- colors
local colors = {
  yellow = "rgb(FFFF00)",
  blue   = "rgb(0000FF)",
  green  = "rgb(00FF00)",
  red    = "rgb(FF0000)",
  white  = "rgb(FFFFFF)",
}

local function border_color(color)
  return color .. " " .. color
end

-- preselect
local preselect_border_size = 3
local preselect = {
  left  = { key = "h", tag = "preselect-left",  color = colors.yellow },
  down  = { key = "j", tag = "preselect-down",  color = colors.green  },
  up    = { key = "k", tag = "preselect-up",    color = colors.blue   },
  right = { key = "l", tag = "preselect-right", color = colors.red    },
}

for _, item in pairs(preselect) do
  hl.window_rule({
    match = { tag = item.tag },
    border_color = border_color(item.color),
    border_size = preselect_border_size,
  })
end

--- split direction
--seq("ALT s", {
--  h = [[ hyprctl dispatch 'hl.dispatch(hl.dsp.window.tag({ tag = "preselect-left" }))' ]],
--  j = [[ hyprctl dispatch 'hl.dispatch(hl.dsp.window.tag({ tag = "preselect-down" }))' ]],
--  k = [[ hyprctl dispatch 'hl.dispatch(hl.dsp.window.tag({ tag = "preselect-up" }))' ]],
--  l = [[ hyprctl dispatch 'hl.dispatch(hl.dsp.window.tag({ tag = "preselect-right" }))' ]],
--})
local function hypr_dispatch_lua(code)
  return [[hyprctl dispatch ]] .. string.format("%q", code)
end

local function tag_window_lua(tag)
  return ([[hl.dispatch(hl.dsp.window.tag({ tag = "%s" }))]]):format(tag)
end

local function untag_window_lua(tag)
  return ([[hl.dispatch(hl.dsp.window.tag({ tag = "-%s" }))]]):format(tag)
end

local function only_preselect_tag(dir)
  local cmds = {}

  for _, item in pairs(preselect) do
    table.insert(cmds, hypr_dispatch_lua(untag_window_lua(item.tag)))
  end

  table.insert(cmds, hypr_dispatch_lua(tag_window_lua(preselect[dir].tag)))

  return table.concat(cmds, " ; ")
end

seq("ALT s", {
  h = only_preselect_tag("left"),
  j = only_preselect_tag("down"),
  k = only_preselect_tag("up"),
  l = only_preselect_tag("right"),
  s = [[ preselect-apply.sh ]]
})
