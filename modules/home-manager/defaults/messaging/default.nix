{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    telegram-desktop
    #discord
    slack 
    #teams
    zoom-us  #=: zoom
  ];
}
