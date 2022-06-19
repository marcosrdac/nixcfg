{ pkgs, config, ... }:

with pkgs.lib;
let
  cfg = config.packaging.flatpak;
in
{
  options.packaging.flatpak.enable = mkEnableOption "Enable default flatpak configuration";

  config.home.packages = with pkgs; mkIf cfg.enable [
    flatpak
  ];

  config.xdg.systemDirs.data = mkIf cfg.enable [
    "/var/lib/flatpak/exports/share"
    "${config.xdg.configHome}/flatpak/exports/share"
  ];
}
