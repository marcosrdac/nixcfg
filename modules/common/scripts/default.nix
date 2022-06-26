{ config, pkgs, nixos, ... }:

with pkgs.lib;
let
  scripts = let
    listDir = dir: builtins.attrNames (builtins.readDir dir);
    bin-dirs = map (d: ./bin/${d}) (listDir ./bin);
    writeScripts = dir: map (n: pkgs.writeScriptBin n (pkgs.lib.fileContents (dir + "/${n}"))) (listDir dir);
  in
    pkgs.lib.flatten (map writeScripts bin-dirs);
in

  if nixos then {
    environment.systemPackages = scripts;
  } else {
    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
    home.packages = scripts;
  }
