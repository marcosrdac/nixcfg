{ config, pkgs, ... }:

{
  host = {
    name = "curupira";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "aarch64-linux";
    nixos = "22.05";
  };

  packages = {
    enable = true;
    extra = with pkgs; [
      rclone
    ];
  };
}
