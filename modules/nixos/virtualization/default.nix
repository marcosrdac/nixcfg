{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.virtualization;
  gcfg = config.graphics;
in
{
  options.virtualization = {
    docker = mkEnableOption "Enable default docker configuration";
    singularity = mkEnableOption "Enable default singularity configuration";
    podman = mkEnableOption "Enable default podman configuration";
    #containerd = mkEnableOption "Enable default singularity configuration";
  };

  config = {
    environment.systemPackages = with pkgs;
      lib.optional cfg.docker docker
      ++ lib.optional cfg.singularity singularity
      ++ lib.optional cfg.podman podman
      ;

      # precondition for enableNvidia below (?)
      #hardware.opengl.driSupport32Bit = lib.optionals (cfg.docker && cfg.graphics.nvidia.enable) true;

      virtualisation.docker = mkIf cfg.docker {
        enable = true;
        enableNvidia = mkIf gcfg.nvidia.enable true;
      };

    virtualisation.containers.enable = mkIf cfg.podman true;
  };
}
