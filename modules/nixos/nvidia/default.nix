{ lib, pkgs, config, ... }:

with pkgs.lib;
let
  cfg = config.nvidia;
in
{
  options.nvidia.enable = mkEnableOption "Enable NVidia configuration" ;

  config = mkIf cfg.enable {
    # maybe needed for tensorflowWithCuda
    hardware.opengl.setLdLibraryPath = true;
  };
}
