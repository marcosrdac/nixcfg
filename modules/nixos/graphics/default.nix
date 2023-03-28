{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.graphics.nvidia;
  nvidiaDriver = pkgs.linuxPackages.nvidia_x11;
in
{
  options.graphics.nvidia = {

    enable = mkEnableOption "Enable NVidia configuration" ;

    prime = mkOption {
      description = "NVidia PRIME configuration";
      type = with types; attrs;
      default = {};
    };

  };

  config = mkIf cfg.enable {
    #nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      #gnumake  # needed?
      #gcc      # needed?

      cudatoolkit
      nvidiaDriver
    ];

    # optionally, you may need to select the appropriate driver version for your specific GPU.
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.opengl.enable = true;

    systemd.services.nvidia-control-devices = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${nvidiaDriver.bin}/bin/nvidia-smi";
    };

    services.xserver = {
      videoDrivers = lib.mkForce [ "nvidia" ];
      # manualy setting dpi for nvidia prime sync
      #dpi = 96;
      # fix Screen tearing (may cause some others problems)
      screenSection = ''
        Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
        Option         "AllowIndirectGLXProtocol" "off"
        Option         "TripleBuffer" "on"
      '';
    };

    # nvidia prime stuff
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.prime = cfg.prime;

    # maybe needed for tensorflowWithCuda (TODO test)
    hardware.opengl.setLdLibraryPath = true;

  };
}
