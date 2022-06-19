{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.bluetooth;
in
{
  options.bluetooth = {
    enable = mkEnableOption "Enable default bluetooth configuration";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
