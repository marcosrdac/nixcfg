{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.virtualization;
in
{
  options.virtualization = {
    docker = mkEnableOption "Enable default docker configuration";
    singularity = mkEnableOption "Enable default singularity configuration";
    #containerd = mkEnableOption "Enable default singularity configuration";
  };

  config = {
    environment.systemPackages = with pkgs;
      lib.optional cfg.docker docker
      ++ lib.optional cfg.singularity singularity;

    virtualisation.docker.enable = mkIf cfg.docker true;
  };
}
