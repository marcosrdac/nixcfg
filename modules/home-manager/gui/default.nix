{ pkgs, config, isNixos, ... }:

with pkgs.lib;
let
  cfg = config.gui;
in
{
  imports = [
    ./managers
    ./bars
    ./compositors
    ./notifiers
    ./launchers
  ];

  options.gui.enable = mkEnableOption "Enable default gui configuration";

  options.gui.scriptPath = mkOption {
    description = "Script that runs the user's graphical interface";
    type = with types; str;
    default = ".xsession";
    example = ".hm-xsession";
  };

  config = {  
    xsession = {
      enable = cfg.enable;
      scriptPath = cfg.scriptPath;
      profileExtra = "${pkgs.feh}/bin/feh --bg-scale ${config.xdg.dataHome}/appearance/wallpaper";
      #profilePath = ".hm-profile";  # apparently does not change it
    };
  };
}
