{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gui.hyprland;
  hyprConfigDir =
    "${config.xdg.configHome}/home-manager/modules/home-manager/gui/managers/hyprland/config";
in {
  options.gui.hyprland = {
    enable = mkEnableOption "Enable Hyprland Wayland compositor";

    package = mkOption {
      type = types.package;
      default = pkgs.hyprland;
      description = "Hyprland package to use.";
    };

    extraConfigFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = "Extra Hyprland config files to source.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra text appended to hyprland.conf.";
    };

    useUWSM = mkOption {
      type = types.bool;
      default = false;
      description = "Start Hyprland through UWSM from the user Wayland session.";
    };

    waylandSessionPath = mkOption {
      type = types.str;
      default = ".wsession";
      description = "Path, relative to HOME, for the user Wayland session script.";
    };
    
    modifier = mkOption {
      type = types.str;
      default = "ALT";
      example = "SUPER";
      description = "Main Hyprland modifier key.";
    };

    gaps = {
      inner = mkOption {
        type = types.int;
        default = 11;
        description = "Inner window gaps.";
      };

      outer = mkOption {
        type = types.int;
        default = 22;
        description = "Outer window gaps.";
      };
    };

    borderWidth = mkOption {
      type = types.int;
      default = 3;
      description = "Hyprland border width.";
    };

    startupPrograms = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = literalExpression ''[ "waybar" "dunst" ]'';
      description = "Commands started by Hyprland at session startup.";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        cfg.package
        foot
        wofi
        waybar
        dunst
        grim
        slurp
        wl-clipboard
        playerctl
        pamixer
        brightnessctl
        hyprpaper
        hyprlock
        hypridle
        arandr
        # scripts
        jq
        yq

      ];
      description = "Extra user packages useful in a Hyprland session.";
    };

  };

  config = mkIf cfg.enable {
    home.packages =
      cfg.extraPackages
      ++ optional cfg.useUWSM pkgs.uwsm;

    home.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";

      # Good default for Electron/Chromium-family apps.
      NIXOS_OZONE_WL = "1";

      # Useful for Qt apps on Wayland.
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # Common wlroots/NVIDIA workaround. Can be removed if it causes issues.
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    home.file.${cfg.waylandSessionPath} = {
      executable = true;
      text = ''
        #!${pkgs.runtimeShell}

        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=Hyprland
        export XDG_SESSION_DESKTOP=Hyprland
        export NIXOS_OZONE_WL=1
        export QT_QPA_PLATFORM='wayland;xcb'
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export WLR_NO_HARDWARE_CURSORS=1

        ${
          if cfg.useUWSM
          then "exec ${pkgs.uwsm}/bin/uwsm start Hyprland"
          else "exec ${cfg.package}/bin/start-hyprland"
        }
      '';
    };

    xdg.configFile = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      cfgPaths =
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair "hypr/${name}" {
            source = mkLink "${hyprConfigDir}/${name}";
          }
        ) (builtins.readDir ./config);
    in cfgPaths // {  # TODO should be written after as a finish script
        "hypr/hm.lua".text = ''
          return {
            mod = "ALT",
            terminal = "kitty",
            browser = "firefox",
          }
        '';
      };

    home.sessionPath = [
      (builtins.toString "${hyprConfigDir}/bin")
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = cfg.package;
      
      # ! We do not want Home Manager to create another login session entry.
      # ! the display manager will start ~/.wsession.
      systemd.enable = false;
      xwayland.enable = true;

      #settings = {
      #  "$mod" = cfg.modifier;

      #  env = [
      #    "XDG_SESSION_TYPE,wayland"
      #    "XDG_CURRENT_DESKTOP,Hyprland"
      #    "XDG_SESSION_DESKTOP,Hyprland"
      #    "NIXOS_OZONE_WL,1"
      #    "QT_QPA_PLATFORM,wayland;xcb"
      #    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      #    "WLR_NO_HARDWARE_CURSORS,1"
      #  ];

      #  exec-once =
      #    [
      #      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
      #    ]
      #    ++ cfg.startupPrograms;

      #  input = {
      #    kb_layout = "us";
      #    kb_variant = "intl";
      #    kb_options = "caps:swapescape";

      #    follow_mouse = 1;

      #    touchpad = {
      #      natural_scroll = false;
      #      tap-to-click = true;
      #    };
      #  };

      #  general = {
      #    gaps_in = cfg.gaps.inner;
      #    gaps_out = cfg.gaps.outer;
      #    border_size = cfg.borderWidth;
      #    layout = "dwindle";
      #  };

      #  decoration = {
      #    rounding = 0;

      #    blur = {
      #      enabled = false;
      #    };

      #    shadow = {
      #      enabled = false;
      #    };
      #  };

      #  animations = {
      #    enabled = false;
      #  };

      #  dwindle = {
      #    #pseudotile = true;
      #    split_width_multiplier = 0.6;
      #    preserve_split = true;
      #  };

      #  misc = {
      #    disable_hyprland_logo = true;
      #    disable_splash_rendering = true;
      #    force_default_wallpaper = 0;
      #  };

      #  bind = [
      #    "$mod, Return, exec, $TERMINAL"
      #    "$mod, B, exec, $BROWSER"
      #    "$mod, O, exec, wofi --show drun"

      #    "$mod SHIFT, Q, killactive"
      #    "$mod SHIFT, E, exit"

      #    "$mod, Space, togglefloating"
      #    "$mod, F, fullscreen"

      #    "$mod, H, movefocus, l"
      #    "$mod, J, movefocus, d"
      #    "$mod, K, movefocus, u"
      #    "$mod, L, movefocus, r"

      #    "$mod, P, cyclenext, prev"
      #    "$mod, N, cyclenext"

      #    "$mod, 1, workspace, 1"
      #    "$mod, 2, workspace, 2"
      #    "$mod, 3, workspace, 3"
      #    "$mod, 4, workspace, 4"
      #    "$mod, 5, workspace, 5"
      #    "$mod, 6, workspace, 6"
      #    "$mod, 7, workspace, 7"
      #    "$mod, 8, workspace, 8"
      #    "$mod, 9, workspace, 9"
      #    "$mod, 0, workspace, 10"

      #    "$mod SHIFT, 1, movetoworkspace, 1"
      #    "$mod SHIFT, 2, movetoworkspace, 2"
      #    "$mod SHIFT, 3, movetoworkspace, 3"
      #    "$mod SHIFT, 4, movetoworkspace, 4"
      #    "$mod SHIFT, 5, movetoworkspace, 5"
      #    "$mod SHIFT, 6, movetoworkspace, 6"
      #    "$mod SHIFT, 7, movetoworkspace, 7"
      #    "$mod SHIFT, 8, movetoworkspace, 8"
      #    "$mod SHIFT, 9, movetoworkspace, 9"
      #    "$mod SHIFT, 0, movetoworkspace, 10"

      #    ", Print, exec, grim - | wl-copy"
      #    "SHIFT, Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      #  ];
      #  
      #  binde = [
      #    "$mod SHIFT, H, movewindow, l"
      #    "$mod SHIFT, J, movewindow, d"
      #    "$mod SHIFT, K, movewindow, u"
      #    "$mod SHIFT, L, movewindow, r"

      #    "$mod CTRL, H, resizeactive, -20 0"
      #    "$mod CTRL, J, resizeactive, 0 20"
      #    "$mod CTRL, K, resizeactive, 0 -20"
      #    "$mod CTRL, L, resizeactive, 20 0"
      #  ];

      #  bindel = [
      #    ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      #    ", XF86AudioLowerVolume, exec, pamixer -d 5"
      #    ", XF86AudioMute, exec, pamixer --toggle-mute"
      #    ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      #    ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      #  ];

      #  bindl = [
      #    ", XF86AudioPlay, exec, playerctl play-pause"
      #    ", XF86AudioNext, exec, playerctl next"
      #    ", XF86AudioPrev, exec, playerctl previous"
      #  ];

      #  bindm = [
      #    "$mod, mouse:272, movewindow"
      #    "$mod, mouse:273, resizewindow"
      #  ];

      #windowrule = [
      #  "match:class ^(float)$, float on"
      #  "match:title ^(popup)$, float on"
      #];

      #};

      #extraConfig = let
      #  mkLink = config.lib.file.mkOutOfStoreSymlink;
      #in
      #  ''
      #    ${concatMapStringsSep "\n" (file: "source = ${file}") (cfg.extraConfigFiles ++ [ (mkLink ./main.config) ])}
      #  ''
      #  + optionalString (cfg.extraConfig != "") ''
      #    
      #    ${cfg.extraConfig}
      #  '';

    };
  };
}
