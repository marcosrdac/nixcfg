{ config, pkgs, ... }:

{
  imports = [
    ./windowManagers/bspwm
    ./bars/polybar
    ./notifications/dunst
    ./compositors/picom
  ];

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    #profileExtra = "${pkgs.pywal}/bin/wal -i $HOME/tmp &";
    #profilePath = ".hm-profile";  # apparently does not change it
  };
}
