{ config, pkgs, ... }:

{
  imports = [
    ./windowManagers/bspwm
    ./bars/polybar
    ./notifications
    ./compositors/picom

    ./windowManagers/riverwm
  ];

  xsession = {
    enable = true;
    scriptPath = ".xsession";
    profileExtra = "${pkgs.feh}/bin/feh --bg-scale ${config.xdg.dataHome}/appearance/wallpaper";
    #profilePath = ".hm-profile";  # apparently does not change it
  };
}
