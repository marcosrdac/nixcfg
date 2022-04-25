{ config, pkgs, ... }:

{
  host = {
    name = "adam";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "21.11";
  };
}
