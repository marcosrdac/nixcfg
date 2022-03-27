{ config, pkgs, ... }:

let
  listModules = dir: map (n: dir + "/${n}") (
    builtins.attrNames (
      pkgs.lib.filterAttrs (n: v: v == "directory") (builtins.readDir dir)
    )
  );
in
{
  imports = [
    ./user-dirs
    ./basic
    ./fonts
    ./terminal
    ./editor
    ./pager
    ./file-browser
    ./web-browser
    ./image-viewer
    ./video-player
    ./music-player
    ./pdf-reader
    ./office-suite
    ./messaging
    ./git
  ];
}
