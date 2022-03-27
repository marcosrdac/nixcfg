{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mpv
  ];

  home.sessionVariables = {
    VIDEOPLAYER = "mpv";
  };
}
