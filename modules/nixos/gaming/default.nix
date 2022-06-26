{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = mkEnableOption "Enable gaming configuration" ;
    steam = mkEnableOption "Enable steam configuration" ;
  };

  config = mkIf cfg.enable {
    hardware.steam-hardware.enable = mkIf cfg.steam true;
    programs.steam = mkIf cfg.steam {
      enable = true;

      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;

      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;
    };
  };
}
