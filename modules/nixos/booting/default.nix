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
      device = mkOption {
        type = with types; uniq str;
        description = ''
          Drive device ID (not to be confused with partition ID) in which to install GRUB. Can be gotten from ls TODO
        '';  # TODO
        default = null;
        example = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
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
    
    tmpOnTmpfs = mkOption {
      description = ''
        Whether to mount /tmp on RAM or not
      '';
      type = with types; bool;
      default = true;
      example = false; 
    };
  };


  config = mkIf cfg.enable (mkMerge [
    { # common
      boot.tmpOnTmpfs = cfg.tmpOnTmpfs;
      boot.loader.grub.useOSProber = cfg.useOSProber;
    }
    
    (mkIf cfg.portable.enable {
      boot.loader = {
        grub = {
          device = cfg.portable.device;
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
        efi.efiSysMountPoint = cfg.portable.efiSysMountPoint;
      };
    })

    (mkIf cfg.efi.enable {
      boot.loader = {
        grub = {
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      };
    })

  ]);
}
