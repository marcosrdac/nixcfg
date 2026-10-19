-- TODO should be set by uwsm if using uwsm
-- another option would be setting env var for user
-- but in such case, the user would not be able to use more than one XDG_SESSION_TYPE, for example
-- see it later. In principle, below works here anyway, it is just not recomended (by looking from afar)

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("NIXOS_OZONE_WL", "1")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.env("WLR_NO_HARDWARE_CURSORS", "1")
