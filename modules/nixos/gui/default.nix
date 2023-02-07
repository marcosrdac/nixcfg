{ lib, pkgs, config, nixos, ... }:

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
      #  enable = true;
      #};

      displayManager.lightdm = {
        enable = true;
        #background = ""; TODO lightdm background
        #extraSeatDefaults = "";
        #extraConfig = ''
          #greeter-hide-users=false
        #'';
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
