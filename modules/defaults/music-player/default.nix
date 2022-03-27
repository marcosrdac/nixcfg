{ config, pkgs, ... }:

{
  imports = [
    ./mpd
    ./spotify
  ];
}
