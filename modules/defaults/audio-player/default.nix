{ config, pkgs, ... }:

{
  imports = [
    ./mpd
    ./spotify
  ];

  xdg.desktopEntries = {
    audio-player = {
      name = "Audio player";
      genericName = "Audio player";
      categories = [ "Application" "Audio" "Player" ];
      exec = "mpv --force-window %u";
    };
  };
}
