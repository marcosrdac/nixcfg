{ config, pkgs, ... }:

#let
#  cfg = config.polybar;
#in
{
  #options.polybar = {
  #  enable = mkEnableOption "Enable polybar configuration";
  #};

  ##services.polybar = mkIf cfg.enable {
  #config = {
    services.polybar = {
      enable = true;
      package = pkgs.unstable.polybar;
      script = pkgs.lib.strings.fileContents ./polybar-start;
      extraConfig = builtins.readFile ./config;
    };
  #};
}
