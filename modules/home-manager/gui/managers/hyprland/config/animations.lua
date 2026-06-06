---- linear	robotic, constant speed
---- almostLinear	subtle, barely noticeable easing
---- quick	snappy, responsive
---- easeOutQuint	fast start, smooth landing
---- easeInOutCubic	symmetric, cinematic
---- default	Hyprland's built-in balanced curve

hl.config({
  animations = {
    enabled = true,
    workspace_wraparound = false,
  },
})

-- curve definitions
hl.curve("easeOutQuint", {
  type = "bezier",
  points = {
    { 0.23, 1.0 },
    { 0.32, 1.0 },
  },
})

hl.curve("easeInOutCubic", {
  type = "bezier",
  points = {
    { 0.65, 0.05 },
    { 0.36, 1.0 },
  },
})

hl.curve("linear", {
  type = "bezier",
  points = {
    { 0.0, 0.0 },
    { 1.0, 1.0 },
  },
})

hl.curve("almostLinear", {
  type = "bezier",
  points = {
    { 0.5, 0.5 },
    { 0.75, 1.0 },
  },
})

hl.curve("quick", {
  type = "bezier",
  points = {
    { 0.15, 0.0 },
    { 0.1, 1.0 },
  },
})

-- animations

hl.animation({
  leaf = "global",
  enabled = true,
  speed = .7,
  bezier = "default",
})

hl.animation({
  leaf = "windows",
  enabled = true,
  speed = .7,
  bezier = "quick",
})

hl.animation({
  leaf = "windowsIn",
  enabled = true,
  speed = .5,
  bezier = "easeOutQuint",
  style = "popin 20%",
})

hl.animation({
  leaf = "windowsOut",
  enabled = true,
  speed = .5,
  bezier = "quick",
  style = "popin 20%",
})

hl.animation({
  leaf = "fade",
  enabled = true,
  speed = .4,
  bezier = "quick",
})

hl.animation({
  leaf = "workspaces",
  enabled = false,
  speed = 2,
  bezier = "easeOutQuint",
  style = "fade",
})
