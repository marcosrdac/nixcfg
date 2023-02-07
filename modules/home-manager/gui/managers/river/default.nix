{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.gui.river;
in {
  options.gui.river = {
    enable = mkEnableOption "Enable river";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #unstable.river
      river
      foot
      slurp grim
      waybar
      xwayland
    ];

    #xsession.windowManager.command = "${pkgs.river}/bin/river";

    xdg.configFile = {
      "river/init" = {
        source = ./init;
        executable = true;
      };
      "river/bar" = {
        source = ./bar;
        executable = true;
      };
    };

    systemd.user.targets.river-session = {
      Unit = {
        Description = "river session";
        Documentation = [ "man:systemd.special(7)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };

    #home.sessionPath = [
    #  (builtins.toString ./bin)
    #];


  };
}
