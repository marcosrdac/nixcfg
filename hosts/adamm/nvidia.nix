{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    #offload.enable = true;
    sync.enable = true;

    # Bus IDs for NVidia and Intel graphics. Use lspci, look for 3D or VGA
    nvidiaBusId = "PCI:1:0:0"; # not "PCI:01:00.0";
    intelBusId = "PCI:0:2:0";  # not "PCI:00:02.0";
  };

  services.xserver = {
    videoDrivers = lib.mkForce [ "nvidia" ];
    # Manualy setting dpi, for nvidia prime sync
    dpi = 96;
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
}
