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
    ./xdg
    ./basic
    ./fonts
    ./terminal
    ./text-editor
    ./text-pager
    ./file-browser
    ./file-transfer
    ./web-browser
    ./image-viewer
    ./video-player
    ./audio-player
    ./pdf-reader
    ./office-suite
    ./messaging
    ./git
  ];
}
