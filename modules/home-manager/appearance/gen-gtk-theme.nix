{ pkgs }:

{ scheme
, name ? scheme.slug
}:

let
  p = scheme.palette;

  css = ''
    @define-color base00 #${p.base00};
    @define-color base01 #${p.base01};
    @define-color base02 #${p.base02};
    @define-color base03 #${p.base03};
    @define-color base04 #${p.base04};
    @define-color base05 #${p.base05};
    @define-color base06 #${p.base06};
    @define-color base07 #${p.base07};
    @define-color base08 #${p.base08};
    @define-color base09 #${p.base09};
    @define-color base0A #${p.base0A};
    @define-color base0B #${p.base0B};
    @define-color base0C #${p.base0C};
    @define-color base0D #${p.base0D};
    @define-color base0E #${p.base0E};
    @define-color base0F #${p.base0F};

    * {
      border-color: @base02;
      outline-color: @base0D;
    }

    window,
    dialog,
    popover,
    menu,
    .background {
      background-color: @base00;
      color: @base05;
    }

    headerbar,
    toolbar,
    .titlebar {
      background-color: @base01;
      color: @base05;
      border-color: @base02;
    }

    button {
      background-color: @base01;
      color: @base05;
      border: 1px solid @base02;
      border-radius: 6px;
      padding: 4px 8px;
    }

    button:hover {
      background-color: @base02;
      color: @base06;
    }

    button:checked,
    button:active {
      background-color: @base0D;
      color: @base00;
    }

    entry,
    spinbutton,
    textview,
    textarea {
      background-color: @base01;
      color: @base05;
      border: 1px solid @base02;
      border-radius: 4px;
    }

    entry:focus,
    spinbutton:focus,
    textview:focus {
      border-color: @base0D;
    }

    selection,
    text selection {
      background-color: @base0D;
      color: @base00;
    }

    notebook tab {
      background-color: @base01;
      color: @base04;
      padding: 4px 8px;
    }

    notebook tab:checked {
      background-color: @base00;
      color: @base05;
      border-bottom: 2px solid @base0D;
    }

    scrollbar slider {
      background-color: @base03;
      border-radius: 8px;
      min-width: 6px;
      min-height: 6px;
    }

    scrollbar slider:hover {
      background-color: @base04;
    }

    trough {
      background-color: @base01;
    }

    progressbar progress {
      background-color: @base0D;
    }

    switch {
      background-color: @base02;
      border-radius: 999px;
    }

    switch:checked {
      background-color: @base0D;
    }

    switch slider {
      background-color: @base05;
      border-radius: 999px;
    }

    tooltip {
      background-color: @base01;
      color: @base05;
      border: 1px solid @base02;
    }

    menuitem:hover,
    modelbutton:hover,
    row:hover {
      background-color: @base01;
    }

    row:selected,
    modelbutton:selected {
      background-color: @base0D;
      color: @base00;
    }

    .error {
      color: @base08;
    }

    .warning {
      color: @base09;
    }

    .success {
      color: @base0B;
    }
  '';
in

pkgs.stdenvNoCC.mkDerivation {
  pname = "gtk-theme-${name}";
  version = "1.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/themes/${name}/gtk-3.0
    mkdir -p $out/share/themes/${name}/gtk-4.0

    cat > $out/share/themes/${name}/gtk-3.0/gtk.css <<'EOF'
    ${css}
    EOF

    cat > $out/share/themes/${name}/gtk-4.0/gtk.css <<'EOF'
    ${css}
    EOF
  '';
}
