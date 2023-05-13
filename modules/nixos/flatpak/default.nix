{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.packaging.flatpak;
in
{
  options.packaging.flatpak = {
    enable = mkEnableOption "Enable default flatpak configuration";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      #extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
    
    services.flatpak.enable = true;

    # NEEDED
    ## sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  };
}
