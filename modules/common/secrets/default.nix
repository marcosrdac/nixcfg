{ config, pkgs, inputs, isNixos, system, ... }:

with pkgs.lib;
let
  cfg = config.secrets;
  packages = with pkgs; [ sops age ];
in
{
  options.secrets = {
    enable = mkEnableOption "Enable secret management";
  };

  config = if isNixos then {
    environment.systemPackages = mkIf cfg.enable packages;
  } else {
    home.packages = mkIf cfg.enable packages;
  };
}
