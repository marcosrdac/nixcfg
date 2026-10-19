-- General window rules

hl.window_rule({
  match = { class = ".*" },
  sync_fullscreen = false,
  min_size = { 1, 1 },
})

-- hl.window_rule({
--   match = {
--     class = "Alacritty",
--   },
--   opacity = "1 override .9 override",
-- })
-- windowrulev2 = opacity 0.94 0.94,class:^(Code|Slack|WebCord|Spotify)$
