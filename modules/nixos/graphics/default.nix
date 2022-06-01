{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.graphics.nvidia;
in
{
  options.graphics.nvidia = {
    enable = mkEnableOption "Enable NVidia configuration" ;
    # TODO CUDA enable
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnumake  # needed?
      gcc      # needed?

      cudatoolkit
    ];

    systemd.services.nvidia-control-devices = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
    };

    #boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    #boot.kernelParams = [ "nvidia-drm.modeset=1" ];
                
    nixpkgs.config.allowUnfree = true;

    # maybe needed for tensorflowWithCuda (TODO test)
    hardware.opengl.setLdLibraryPath = true;

    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.prime = {
      #offload.enable = true;
      sync.enable = true;
      # Bus IDs for NVidia and Intel graphics. Use lspci, look for 3D or VGA
      nvidiaBusId = "PCI:1:0:0"; # not "PCI:01:00.0";  # TODO host dependent!
      intelBusId = "PCI:0:2:0";  # not "PCI:00:02.0";
    };

    services.xserver = {
      videoDrivers = lib.mkForce [ "nvidia" ];
      # Manualy setting dpi, for nvidia prime sync
      #dpi = 96;
      # Fix Screen tearing (may cause some others problems)
      screenSection = ''
        Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
        Option         "AllowIndirectGLXProtocol" "off"
        Option         "TripleBuffer" "on"
      '';
    };

    hardware.opengl.enable = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  };
}
