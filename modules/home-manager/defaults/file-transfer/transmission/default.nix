{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    transmission_4
    tremc
  ];

  home.sessionPath = [
    (toString ./bin)
  ];

  xdg.configFile."transmission-daemon/settings.json" = {
    text = import ./settings.json.nix config pkgs;
  };
}
