{ pkgs }:

{ scheme
, name ? "gradience-${scheme.slug}"
}:

let
  p = scheme.palette;

  # Base16 semantic mapping
  bg        = p.base00;
  surface   = p.base01;
  surface2  = p.base02;
  muted     = p.base03;
  subtle    = p.base04;
  fg        = p.base05;
  fgStrong  = p.base06;
  accent    = p.base0D;
  success   = p.base0B;
  warning   = p.base09;
  error     = p.base08;

  gtk4Css = ''
    /*
      Generated from nix-colors using an Adwaita/Gradience-like token model.
      This is not produced by Gradience itself.
    */

    @define-color accent_color #${accent};
    @define-color accent_bg_color #${accent};
    @define-color accent_fg_color #${bg};

    @define-color destructive_color #${error};
    @define-color destructive_bg_color #${error};
    @define-color destructive_fg_color #${bg};

    @define-color success_color #${success};
    @define-color success_bg_color #${success};
    @define-color success_fg_color #${bg};

    @define-color warning_color #${warning};
    @define-color warning_bg_color #${warning};
    @define-color warning_fg_color #${bg};

    @define-color error_color #${error};
    @define-color error_bg_color #${error};
    @define-color error_fg_color #${bg};

    @define-color window_bg_color #${bg};
    @define-color window_fg_color #${fg};

    @define-color view_bg_color #${bg};
    @define-color view_fg_color #${fg};

    @define-color headerbar_bg_color #${surface};
    @define-color headerbar_fg_color #${fgStrong};
    @define-color headerbar_border_color #${surface2};
    @define-color headerbar_backdrop_color #${bg};
    @define-color headerbar_shade_color rgba(0, 0, 0, 0.36);
    @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.90);

    @define-color sidebar_bg_color #${surface};
    @define-color sidebar_fg_color #${fg};
    @define-color sidebar_backdrop_color #${bg};
    @define-color sidebar_shade_color rgba(0, 0, 0, 0.25);
    @define-color sidebar_border_color #${surface2};

    @define-color secondary_sidebar_bg_color #${surface};
    @define-color secondary_sidebar_fg_color #${fg};
    @define-color secondary_sidebar_backdrop_color #${bg};
    @define-color secondary_sidebar_shade_color rgba(0, 0, 0, 0.25);
    @define-color secondary_sidebar_border_color #${surface2};

    @define-color card_bg_color #${surface};
    @define-color card_fg_color #${fg};
    @define-color card_shade_color rgba(0, 0, 0, 0.36);

    @define-color dialog_bg_color #${surface};
    @define-color dialog_fg_color #${fg};

    @define-color popover_bg_color #${surface};
    @define-color popover_fg_color #${fg};
    @define-color popover_shade_color rgba(0, 0, 0, 0.36);

    @define-color shade_color rgba(0, 0, 0, 0.36);
    @define-color scrollbar_outline_color #${bg};

    @define-color blue_1 #${p.base0D};
    @define-color blue_2 #${p.base0D};
    @define-color blue_3 #${p.base0D};
    @define-color blue_4 #${p.base0D};
    @define-color blue_5 #${p.base0D};

    @define-color green_1 #${p.base0B};
    @define-color green_2 #${p.base0B};
    @define-color green_3 #${p.base0B};
    @define-color green_4 #${p.base0B};
    @define-color green_5 #${p.base0B};

    @define-color yellow_1 #${p.base0A};
    @define-color yellow_2 #${p.base0A};
    @define-color yellow_3 #${p.base0A};
    @define-color yellow_4 #${p.base0A};
    @define-color yellow_5 #${p.base0A};

    @define-color orange_1 #${p.base09};
    @define-color orange_2 #${p.base09};
    @define-color orange_3 #${p.base09};
    @define-color orange_4 #${p.base09};
    @define-color orange_5 #${p.base09};

    @define-color red_1 #${p.base08};
    @define-color red_2 #${p.base08};
    @define-color red_3 #${p.base08};
    @define-color red_4 #${p.base08};
    @define-color red_5 #${p.base08};

    @define-color purple_1 #${p.base0E};
    @define-color purple_2 #${p.base0E};
    @define-color purple_3 #${p.base0E};
    @define-color purple_4 #${p.base0E};
    @define-color purple_5 #${p.base0E};

    @define-color brown_1 #${p.base0F};
    @define-color brown_2 #${p.base0F};
    @define-color brown_3 #${p.base0F};
    @define-color brown_4 #${p.base0F};
    @define-color brown_5 #${p.base0F};

    /*
      Small compatibility layer.
      Keep this restrained: Gradience-like themes should mostly work by
      redefining Adwaita color tokens, not by restyling every widget.
    */

    window,
    .background {
      background-color: @window_bg_color;
      color: @window_fg_color;
    }

    headerbar,
    .titlebar {
      background-color: @headerbar_bg_color;
      color: @headerbar_fg_color;
      border-color: @headerbar_border_color;
    }

    .card,
    preferencesgroup,
    expander {
      background-color: @card_bg_color;
      color: @card_fg_color;
    }

    popover,
    menu,
    .popover {
      background-color: @popover_bg_color;
      color: @popover_fg_color;
    }

    entry,
    textview,
    spinbutton {
      background-color: @view_bg_color;
      color: @view_fg_color;
      border-color: #${surface2};
    }

    selection,
    text selection {
      background-color: @accent_bg_color;
      color: @accent_fg_color;
    }
  '';

  # GTK3 does not fully understand the same libadwaita model,
  # but adw-gtk3-like themes use many equivalent names.
  gtk3Css = gtk4Css + ''
    @define-color theme_bg_color #${bg};
    @define-color theme_fg_color #${fg};
    @define-color theme_base_color #${bg};
    @define-color theme_text_color #${fg};
    @define-color theme_selected_bg_color #${accent};
    @define-color theme_selected_fg_color #${bg};
    @define-color insensitive_bg_color #${surface};
    @define-color insensitive_fg_color #${subtle};
    @define-color borders #${surface2};
    @define-color unfocused_borders #${surface};

    button {
      background-color: #${surface};
      color: #${fg};
      border-color: #${surface2};
    }

    button:hover {
      background-color: #${surface2};
    }

    button:checked,
    button:active {
      background-color: @accent_bg_color;
      color: @accent_fg_color;
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
    ${gtk3Css}
    EOF

    cat > $out/share/themes/${name}/gtk-4.0/gtk.css <<'EOF'
    ${gtk4Css}
    EOF
  '';
}
