{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.graphics.nvidia;
in
{
  options.graphics.nvidia = {

    enable = mkEnableOption "Enable NVidia configuration";

    open = mkOption {
      description = "Use open NVidia drivers";
      type = with types; bool;
      default = true;
    };

    driver = mkOption {
      description = "NVidia driver to be installed";
      type = with types; package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    prime = mkOption {
      description = "NVidia PRIME configuration";
      type = with types; attrs;
      default = {};
    };

  };

  config = mkIf cfg.enable {
    #nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      #cfg.driver
      #gnumake  # needed?
      #gcc      # needed?

      # https://github.com/NixOS/nixpkgs/blob/4d5b1d6b273fc4acd5dce966d2e9c0ca197b6df2/pkgs/development/compilers/cudatoolkit/default.nix
      #cudatoolkit_11  # TODO test removing, see how it went
      # https://github.com/NixOS/nixpkgs/blob/634141959076a8ab69ca2cca0f266852256d79ee/pkgs/development/libraries/science/math/cudnn/default.nix
      #cudnn_8_3_cudatoolkit_11  # TODO test removing, see how it went
    ];

    # optionally, you may need to select the appropriate driver version for your specific GPU.
    hardware.nvidia.open = cfg.open;
    hardware.nvidia.package = cfg.driver;
    hardware.graphics.enable = true;

    systemd.services.nvidia-control-devices = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${cfg.driver.bin}/bin/nvidia-smi";
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
    hardware.nvidia.prime = cfg.prime;  # // { offload.enable = true; offload.enableOffloadCmd = true;  };
  };
}
