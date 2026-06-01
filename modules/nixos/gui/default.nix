#TODO add hyprland portal enable option 
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.gui;

    userWaylandSession = pkgs.stdenv.mkDerivation {
    name = "user-wayland-session";

    buildCommand = ''
      mkdir -p $out/bin
      mkdir -p $out/share/wayland-sessions

      cat > $out/bin/user-wayland-session <<'EOF'
  #!${pkgs.runtimeShell}
  set -eu

  script_path="${cfg.wayland.scriptPath}"

  user_home="$(${pkgs.getent}/bin/getent passwd "$USER" | ${pkgs.coreutils}/bin/cut -d: -f6)"

  if [ -z "$user_home" ] || [ ! -d "$user_home" ]; then
    echo "Could not determine home directory for user: $USER" >&2
    exit 1
  fi

  session_script="$user_home/$script_path"

  if [ ! -f "$session_script" ]; then
    echo "User Wayland session script not found: $session_script" >&2
    exit 1
  fi

  exec ${pkgs.bash}/bin/bash "$session_script"
  EOF

      chmod +x $out/bin/user-wayland-session

      cat > $out/share/wayland-sessions/user-wayland.desktop <<EOF
  [Desktop Entry]
  Name=custom:wayland
  Comment=Run user's Wayland session script
  Exec=$out/bin/user-wayland-session
  Type=Application
  DesktopNames=user-wayland
  EOF
    '';

    passthru.providedSessions = [ "user-wayland" ];
  };

in {
  options.gui = {
    enable = mkEnableOption "graphical system support";

    displayManager = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable graphical display manager.";
      };

      name = mkOption {
        type = types.enum [ "sddm" "ly" ];
        default = "ly";
        description = "Display manager to use.";
      };

      defaultSession = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "user-wayland";
        description = "Optional default display manager session.";
      };
    };

    x11 = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable X11 support.";
      };

      userSession.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Expose a generic X11 session that runs a user script.";
      };

      scriptPath = mkOption {
        type = types.str;
        default = ".xsession";
        example = ".hm-xsession";
        description = "User X11 session script path, relative to HOME.";
      };
    };

    wayland = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable generic Wayland support.";
      };

      userSession.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Expose a generic Wayland session that runs a user script.";
      };

      scriptPath = mkOption {
        type = types.str;
        default = ".wsession";
        example = ".config/nixcfg/wayland-session";
        description = "User Wayland session script path, relative to HOME.";
      };

      xwayland.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable XWayland support.";
      };

      seatd.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable seatd for Wayland compositors that need seat management.";
      };

      portals.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable XDG desktop portals for Wayland/X11 desktop integration.";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # TODO talvez só deveria ser habilitado se habilitarmos wayland
      programs.dconf.enable = mkDefault true;

      security.polkit.enable = mkDefault true;
      services.dbus.enable = mkDefault true;

      services.graphical-desktop.enable = mkDefault true;

      services.displayManager = mkIf cfg.displayManager.enable {
        defaultSession =
          mkIf (cfg.displayManager.defaultSession != null)
            cfg.displayManager.defaultSession;

        sddm.enable =
          mkIf (cfg.displayManager.name == "sddm") true;

        ly = mkIf (cfg.displayManager.name == "ly") {
          enable = true;

          settings = {
            save = true;
            load = true;
            default_input = "password";
            animation = "none";
            clock = "%Y-%m-%d %H:%M";
            hide_version_string = true;
            initial_info_text = config.networking.hostName or "nixos";
          };
        };
      };
    }

    (mkIf cfg.x11.enable {
      services.xserver = {
        enable = true;
        autorun = mkDefault true;
        exportConfiguration = mkDefault true;
        updateDbusEnvironment = mkDefault true;

        desktopManager = {
          runXdgAutostartIfNone = mkDefault true;

          session = mkIf cfg.x11.userSession.enable [
            {
              name = "custom:x11";
              start = ''
                ${pkgs.runtimeShell} "$HOME/${cfg.x11.scriptPath}" &
                waitPID=$!
              '';
            }
          ];
        };
      };
    })

    (mkIf cfg.wayland.enable {
      programs.xwayland.enable =
        mkIf cfg.wayland.xwayland.enable (mkDefault true);

      programs.uwsm.enable = mkDefault true;
      services.seatd.enable = mkIf cfg.wayland.seatd.enable true;

      services.displayManager.sessionPackages =
        mkIf cfg.wayland.userSession.enable [
          userWaylandSession
        ];

      xdg.portal = mkIf cfg.wayland.portals.enable {
        enable = true;

        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
          xdg-desktop-portal-hyprland
        ];

        config = {
          common = {
            default = [ "gtk" ];

            "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          };

          hyprland = {
            default = [ "hyprland" "gtk" ];

            "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
          };
        };
      };
    })
  ]);
}
