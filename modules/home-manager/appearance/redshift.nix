{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.appearance.redshift;
in {

  options.appearance.redshift = {
    enable = mkEnableOption "Enable redshift";
  };

  config = mkIf cfg.enable {
    services.redshift.enable = cfg.enable;
    services.redshift.provider = "geoclue2";
  };
}
