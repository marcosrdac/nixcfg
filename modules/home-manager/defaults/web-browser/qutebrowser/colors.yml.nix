colorscheme: with colorscheme.colors;
''
colors:
  statusbar:
    caret:
      bg: "#${base00}"
      fg: "#${base05}"
    passthrough:
      bg: "#${base00}"
      fg: "#${base05}"
    command:
      bg: "#${base05}"
      fg: "#${base00}"
      private:
        bg: "#${base00}"
        fg: "#${base05}"
    insert:
      bg: "#${base05}"
      fg: "#${base00}"
    normal:
      bg: "#${base00}"
      fg: "#${base05}"
    private:
      bg: "#${base05}"
      fg: "#${base00}"
    progress:
      bg: "#${base05}"
    url:
      fg: "#${base0E}"
      error:
        fg: "#${base0A}"
      hover:
        fg: "#${base05}"
      success:
        http:
          fg: "#${base05}"
        https:
          fg: "#${base0B}"
      warn:
        fg: "#${base0A}"
  tabs:
    bar:
      bg: "#${base00}"
    even:
      fg: "#${base05}"
      bg: "#${base00}"
    odd:
      fg: "#${base05}"
      bg: "#${base00}"
    selected:
      even:
        fg: "#${base00}"
        bg: "#${base05}"
      odd:
        fg: "#${base00}"
        bg: "#${base05}"
  completion:
    category:
      bg: "#${base05}"
      fg: "#${base00}"
      border:
        bottom: "#${base05}"
        top: "#${base05}"
    even:
      bg: "#${base00}"
    odd:
      bg: "#${base00}"
    item:
      selected:
        bg: "#${base05}"
        fg: "#${base00}"
        border:
          bottom: "#${base00}"
          top:  "#${base00}"
    match:
      fg: "#${base0B}"
    scrollbar:
      bg: "#${base05}"
      fg: "#${base00}"
  downloads:
    bar:
      bg: "#${base00}"
    error:
      fg: "#${base05}"
      bg: "#${base0B}"
    start:
      fg: "#${base05}"
      bg: "#${base00}"
    stop:
      fg: "#${base05}"
      bg: "#${base0A}"
  hints:
    fg: "#${base05}"
    bg: "#${base00}"
    match:
      fg: "#${base0B}"
  keyhint:
    fg: "#${base05}"
    bg: "#${base00}"
    suffix:
      fg: "#${base0A}"
  messages:
    error:
      fg: "#${base00}"
      bg: "#${base0A}"
      border: "#${base0A}"
    info:
      fg: "#${base00}"
      bg: "#${base05}"
      border: "#${base05}"
    warning:
      fg: "#${base05}"
      bg: "#${base0A}"
      border: "#${base0A}"
  prompts:
    fg: "#${base05}"
    bg: "#${base00}"
    border: "#${base00}"
    selected:
      bg: "#${base0A}"
  webpage:
    bg: "#${base05}"
    preferred_color_scheme: "${colorscheme.kind}"
hints:
  border: "1px solid #${base05}"
''
