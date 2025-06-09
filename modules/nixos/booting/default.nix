{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.booting;
in
{
  options.booting = {
    enable = mkEnableOption "Enable default host configuration";

    # TODO ADD OCI BOOT
    portable = {
      enable = mkEnableOption ''
        Cofigure NixOS for a removable drive (compatible with both MBR and EFI loaders)
        TODO describe partition setup required
      '';
      # TODO remove this? (because of devices opt below
      device = mkOption {
        type = with types; uniq str;
        description = ''
          Drive device ID (not to be confused with partition ID) in which to install GRUB. Can be gotten from ls TODO
        '';  # TODO
        default = null;
        example = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
      };
      devices = mkOption {
        type = with types; listOf str;
        description = ''
          Drive device ID (not to be confused with partition ID) in which to install GRUB. Can be gotten from ls TODO
        '';  # TODO
        default = [ "nodev" ];
        example = [ "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF" ];
      };
      efiSysMountPoint = mkOption {
        description = "Mount point for EFI system";
        type = with types; uniq str;
        default = "/efi";
      };
    };

    efi = {
      enable = mkEnableOption ''
        Cofigure NixOS for a removable drive (compatible with both MBR and EFI loaders)
        TODO describe partition setup required
      '';
    };

    useOSProber = mkEnableOption ''
      Whether to search for other operational systems for boot menu or not
    '';
    
    tmp.useTmpfs = mkOption {
      description = ''
        Whether to mount /tmp on RAM or not
      '';
      type = with types; bool;
      default = true;
      example = false; 
    };

    tmp.tmpfsSize = mkOption {
      description = ''
        Size of /tmp if it is mounted on RAM or not
      '';
      type = with types; str;
      default = "2G";
      example = "20%";
    };

    runtimeDirectorySize = mkOption {
      description = ''
        RAM size allowed for /run/user/USERID
      '';
      type = with types; str;
      default = "1G";
      example = "2G";
    };

  };


  config = mkIf cfg.enable (mkMerge [
    { # common
      boot.tmp.useTmpfs = cfg.tmp.useTmpfs;
      boot.tmp.tmpfsSize = cfg.tmp.tmpfsSize;
      boot.tmp.cleanOnBoot = !config.boot.tmp.cleanOnBoot;
      boot.loader.grub.useOSProber = cfg.useOSProber;

      services.logind.extraConfig = ''
        RuntimeDirectorySize=${cfg.runtimeDirectorySize}
        RuntimeDirectoryInodesMax=1048576  
      '';
    }
    
    (mkIf cfg.portable.enable {
      boot.loader = {
        grub = {
          devices = cfg.portable.devices;
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
        efi.efiSysMountPoint = cfg.portable.efiSysMountPoint;
      };
    })

    (mkIf cfg.efi.enable {
      boot.loader = {
        efi.efiSysMountPoint = cfg.portable.efiSysMountPoint;
        grub = {
          devices = [ "nodev" ];  # not actually used: just passes assertion
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      };
    })

  ]);
}
