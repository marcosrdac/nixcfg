{ config, pkgs, lib, ... }:

# https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/services/x11/desktop-managers
# xfce
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/x11/desktop-managers/xfce.nix
# TODO add MATE!
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/x11/desktop-managers/mate.nix
# set xserver.dpi on nixos

with lib;
let
  cfg = config.gui.xfce;
in {

  options.gui.xfce = {
    enable = mkEnableOption "Enable BSPWM (and SXHKD)";

    thunarPlugins = mkOption {
      default = [];
      type = types.listOf types.package;
      example = literalExpression "[ pkgs.xfce.thunar-archive-plugin ]";
      description = ''
        A list of plugin that should be installed with Thunar.
      '';
    };

    noDesktop = mkOption {
      type = types.bool;
      default = false;
      description = "Don't install XFCE desktop components (xfdesktop and panel).";
    };

    enableXfwm = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the XFWM (default) window manager.";
    };

    enableScreensaver = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the XFCE screensaver.";
    };
  };


  config = mkIf cfg.enable {

    home.packages = with pkgs.xfce // pkgs; [
      glib # for gsettings
      gtk3.out # gtk-update-icon-cache

      gnome.gnome-themes-extra
      gnome.adwaita-icon-theme
      hicolor-icon-theme
      tango-icon-theme
      xfce4-icon-theme

      desktop-file-utils
      shared-mime-info # for update-mime-database

      # For a polkit authentication agent
      polkit_gnome

      # Needed by Xfce's xinitrc script
      xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/

      exo
      garcon
      libxfce4ui
      xfconf

      mousepad
      parole
      ristretto
      xfce4-appfinder
      xfce4-notifyd
      xfce4-screenshooter
      xfce4-session
      xfce4-settings
      xfce4-taskmanager
      xfce4-terminal

      #(thunar.override { thunarPlugins = cfg.thunarPlugins; })
    ] # TODO: NetworkManager doesn't belong here
      #++ optional config.networking.networkmanager.enable networkmanagerapplet
      #++ optional config.powerManagement.enable xfce4-power-manager
      #++ optionals config.hardware.pulseaudio.enable [
        #pavucontrol
        # volume up/down keys support:
        # xfce4-pulseaudio-plugin includes all the functionalities of xfce4-volumed-pulse
        # but can only be used with xfce4-panel, so for no-desktop usage we still include
        # xfce4-volumed-pulse
        #(if cfg.noDesktop then xfce4-volumed-pulse else xfce4-pulseaudio-plugin)
      #]
      ++ [
      #++ optionals cfg.enableXfwm [
        xfwm4
        xfwm4-themes
      #]
      #++ optionals (!cfg.noDesktop) [
        xfce4-panel
        xfdesktop
      #] ++ optional cfg.enableScreensaver xfce4-screensaver;
      ]
      ;

    # TODO see xfce4-session xinitrc
    # TODO investigate nixos xfce module

    # maybe read xresources before!
    xsession.windowManager.command = "exec xfce4-session";

  };

      #home.file.graphicsScript = {
        #target = config.gui.scriptPath;
        #source = pkgs.xfce.xfce4-session.xinitrc;
        #executable = true;
      #};

      #systemd.packages = with pkgs.xfce; [
        #(thunar.override { thunarPlugins = cfg.thunarPlugins; })
        #xfce4-notifyd
      #];
    
}
