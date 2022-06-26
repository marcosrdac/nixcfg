{ config, pkgs, ... }:

{
  imports = [
    ./transmission
  ];

  xdg.desktopEntries = {
    torrent-manager = {
      name = "Torrent manager";
      genericName = "Torrent manager";
      exec = let
        torrent-add = pkgs.writeShellScriptBin "torrent-add" (pkgs.lib.strings.fileContents ./transmission/bin/torrent-add);
      in "${builtins.toString torrent-add}/bin/torrent-add %u";
      categories = [ "Application" "Network" "FileTransfer" ];  
    };
  };
}
