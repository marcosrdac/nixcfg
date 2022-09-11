{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.mounter;
in
{
  options.mounter = {
    enable = mkEnableOption "Enable default mounter host configuration";
  };

  config = mkIf cfg.enable {
    programs.udevil.enable = true;
  };
}
