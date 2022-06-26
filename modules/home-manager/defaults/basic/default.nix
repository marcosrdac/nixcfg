{ config, pkgs, ... }:

{  # move to common/basic? (!)
  home.packages = with pkgs; [
    htop 
    xclip xsel
    ydotool xdotool
  ];
}
