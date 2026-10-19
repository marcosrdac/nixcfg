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
        yad
        colorthief  # an overlay here
        #material-theme-image  # an overlay here
        color-extract  # an overlay here
        pastel
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
    in {
      "hypr" = { source = mkLink hyprConfigDir; };
    };

    # TODO should be written after as a finish script
    #"hypr/hm.lua".text = ''
    #  return {
    #    mod = "ALT",
    #    terminal = "kitty",
    #    browser = "firefox",
    #  }
    #'';

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

      # even though I am using lua; I believe this is just for the nix module
      configType = "hyprlang";
      #settings = {
      #  "$mod" = cfg.modifier;

      # TODO add env vars to uswm config too (if it is being used cfg.useUSWM)
      #  env = [
      #    "XDG_SESSION_TYPE,wayland"
      #    "XDG_CURRENT_DESKTOP,Hyprland"
      #    "XDG_SESSION_DESKTOP,Hyprland"
      #    "NIXOS_OZONE_WL,1"
      #    "QT_QPA_PLATFORM,wayland;xcb"
      #    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      #    "WLR_NO_HARDWARE_CURSORS,1"
      #  ];

      # TODO add exec-one stuff, or open them as services
      #  exec-once =
      #    [
      #      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE"
      #    ]
      #    ++ cfg.startupPrograms;
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
