{ config, pkgs, ... }:

{
  imports = [
    ./bspwm
    ./picom
  ];

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    #profileExtra = "${pkgs.pywal}/bin/wal -i $HOME/tmp &";
    #profilePath = ".hm-profile";  # apparently does not change it
  };
}
