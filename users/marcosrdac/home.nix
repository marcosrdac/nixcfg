{ config, pkgs, ... }:

{
  imports = [ ];

  #xdg.configFile = let
  #  mkLink = config.lib.file.mkOutOfStoreSymlink;
  #in {
  #  "GIMP" = {
  #    source = ../../config/GIMP;
  #    recursive = true;
  #  };
  #};

  services.network-manager-applet.enable = true;

  home.keyboard = {
    #layout = "br";
    layout = "us";
    variant = "intl";
    options = [ "caps:swapescape" ];
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    #(callPackage (import ./packages/nvim) {})
    nox
    neofetch

    p7zip
    zip

    ripgrep

    fzy

    scrot
    brightnessctl  # light control
    pamixer        # sound control

    julia_16-bin

    tmatrix

    keepassxc
    lxappearance
  ];
}
