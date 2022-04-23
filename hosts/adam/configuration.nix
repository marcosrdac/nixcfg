{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    #./nvidia.nix
  ];

  hostConfig = {
    enable = true;

    machine = {
      hostName = "adam";
      timeZone = "Brazil/East";
      locale = "en_US.UTF-8";
      stateVersion = "21.11";
    };

    boot = {
      loader.portable = {
        enable = true;
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
        efiSysMountPoint = "/efi";
      };
      tmpOnTmpfs = false;
    };

    devices = {
      network = {
        interfaces = [ "enp2s0" "wlp3s0" ];
      };
    };

    packages = with pkgs; {
      extra = [ ];
    };

    users = {
      available = {
        marcosrdac = {
	  description = "Marcos Conceição";
          isNormalUser = true;
          extraGroups = [ "nixcfg" "wheel" "networkmanager" "vboxusers" "lp" ];  # maybe lp should not be extra group but commom group? (just group idk)
        };
        guest = {
	  description = "Guest";
          isNormalUser = true;
          extraGroups = [ "networkmanager" "lp" ];
        };
      };
    };

  };

  services.logind.extraConfig = ''
    RuntimeDirectorySize=8G
    RuntimeDirectoryInodesMax=1048576  
  '';
}
