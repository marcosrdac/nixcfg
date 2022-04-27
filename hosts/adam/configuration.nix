{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    #./nvidia.nix
  ];

  host = {
    name = "adam";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "21.11";
  };

  keyboard = {
    enable = true;
    xorg = {
      layout = "us";
      variant = "intl";
      options = "caps:swapescape";
    };
    console = {
      layout = "us";
    };
  };

  print = {
    enable = true;
    drivers = with pkgs; [ epson-escpr ];
  };

  network = {
    enable = true;
    interfaces = [ "enp2s0" "wlp3s0" ];
    sshServer = true;
  };

  variables = {
    enable = true;
    overrides = { };
  };

  audio = {  # uneeded
    enable = true;
  };

  hostUsers = {
    available = {
      marcosrdac = {
        description = "Marcos Conceição";
        isNormalUser = true;
        extraGroups = [ "nixcfg" "wheel" "vboxusers" ];
      };
      guest = {
        description = "Guest";
        isNormalUser = true;
      };
    };
    defaultGroups = [ "networkmanager" "lp" ];
  };

  gui = {
    enable = true;
  };

  packages = {
    enable = true;
    design = true;
    #extra = [ ];
  };

  bootTemplates = {
    enable = true;
    portable = {
      enable = true;
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
    };
    tmpOnTmpfs = false;
  };

  services.logind.extraConfig = ''
    RuntimeDirectorySize=8G
    RuntimeDirectoryInodesMax=1048576  
  '';
}
