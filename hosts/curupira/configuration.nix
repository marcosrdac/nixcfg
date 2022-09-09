{ config, pkgs, ... }:

{
  imports = [
    ./oci
    ./hardware-configuration.nix
  ];

  host = {
    name = "curupira";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "aarch64-linux";
    nixos = "22.05";
  };

  environment.systemPackages = with pkgs; [
    lf
    vim
    neovim
    wget
    git
  ];
}
