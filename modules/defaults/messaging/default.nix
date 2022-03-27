{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tdesktop  #=: telegram
    discord
    teams zoom-us
  ];
}
