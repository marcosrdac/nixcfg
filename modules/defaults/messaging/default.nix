{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tdesktop  #=: telegram
    discord
    slack 
    teams
    zoom-us  #=: zoom
  ];
}
