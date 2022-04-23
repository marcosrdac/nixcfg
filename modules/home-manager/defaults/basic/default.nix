{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    htop 
    xclip xsel
    ydotool xdotool
  ];
}
