{ config, pkgs, ... }:

{
  imports = [
    ./dunst
  ];

  home.packages = with pkgs; [
    libnotify  #=: notify-send
  ];
}
