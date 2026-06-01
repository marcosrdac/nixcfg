#TODO add hyprland portal enable option 
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.gui;

  userWaylandSession = pkgs.stdenv.mkDerivation {
    name = "user-wayland-session";

    buildCommand = ''
      mkdir -p $out/share/wayland-sessions

      cat > $out/share/wayland-sessions/user-wayland.desktop <<EOF
[Desktop Entry]
Name=User Wayland Session
Comment=Run user's Wayland session script
Exec=${pkgs.bash}/bin/bash -lc 'exec ${pkgs.bash}/bin/bash "$HOME/${cfg.wayland.scriptPath}"'
Type=Application
DesktopNames=user-wayland
EOF
    '';
# old Exec not working even though `bash .waylandsession` worked
# Exec=${pkgs.bash}/bin/bash -lc 'exec ${pkgs.dbus}/bin/dbus-run-session -- ${pkgs.bash}/bin/bash "$HOME/${cfg.wayland.scriptPath}"'

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

      sddm.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable SDDM display manager.";
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
        default = ".waylandsession";
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
        sddm.enable = mkIf cfg.displayManager.sddm.enable true;

        defaultSession =
          mkIf (cfg.displayManager.defaultSession != null)
            cfg.displayManager.defaultSession;
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
              name = "X11-User";
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
