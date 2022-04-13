{ config, pkgs, ... }:

{
  imports = [
    ./directories.nix
    ./programs.nix
  ];
}
