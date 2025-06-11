{ lib, pkgs, config, isNixos, ... }:

with lib;
let
  cfg = config.gui;
in
{
  options.gui.enable = mkEnableOption "Enable default gui configuration";

  options.gui.scriptPath = mkOption {
    description = "Script that runs the user's graphical interface";
    type = with types; str;
    default = ".xsession";
    example = ".hm-xsession";
  };

  config = mkIf cfg.enable {
    # GENERALLY NEEDED
    programs.dconf.enable = true;

    services.xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;

      updateDbusEnvironment = true;  # TODO dbus needed (to test)

      #desktopManager.gnome.enable = true;

      desktopManager.session = [
        {
          name = "Custom";
          start = ''
            ${pkgs.runtimeShell} $HOME/${cfg.scriptPath} &
            waitPID=$!
          '';
        }
      ];

      #displayManager.gdm = {
      #displayManager.sddm = {
      #  enable = true;
      #};

      displayManager.lightdm = {
        enable = true;
        #background = "#223b54";
        #background = "#132332";
        #background = ""; TODO lightdm background
        #extraSeatDefaults = "";
        #greeters.slick = {
        greeters.gtk = {
          enable = true;
          #extraConfig = ''
          #'';
        };
        # https://github.com/cboursnell/i3install/blob/master/lightdm-gtk-greeter.conf
        extraConfig = ''
          [Greeter]
          indicators=~host;~spacer;~clock;~spacer;~session;~language;~a11y;~power
          background-color=#223b54
          background=#223b54
          hide-user-image=#223b54
          clock-format = %A %d %B, %H:%M
          position = 25%,start 50%,center
          user-background = false
        '';
        #background = #2e3436
        #theme-name = Adwaita-dark
        #icon-theme-name = Adwaita
        #font-name = Noto Mono 10
      };

      #desktopManager.xfce.enable = true; # TODO create module, not true by default (like below)
      #desktopManager.xfce.enable = cfg.enableXfceSession;
      ## nixos
      #enableXfceSession = mkOption {
      #  description = "Enable default host configuration";
      #  type = with types; bool;
      #  default = true;  # TODO default false?
      #};
    };
  };
}
