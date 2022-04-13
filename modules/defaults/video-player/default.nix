{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mpv
  ];

  home.sessionVariables = {
    VIDEOPLAYER = "mpv";
  };

  xdg.desktopEntries = {
    video-player = {
      name = "Video viewer";
      categories = [ "Application" "Video" "Player" ];
      exec = "mpv --force-window %u";
    };
  };
}
