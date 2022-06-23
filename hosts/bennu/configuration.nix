{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  host = {
    name = "bennu";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.05";
  };

  gui.enable = true;
  #graphics.nvidia.enable = true;

  #booting = {
  #  enable = true;
  #  portable = {
  #    enable = true;
  #    device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
  #  };
  #  tmpOnTmpfs = false;
  #};
  
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  services.logind.extraConfig = ''
    RuntimeDirectorySize=8G
    RuntimeDirectoryInodesMax=1048576  
  '';

  keyboard = {
    enable = true;
    gui = {
      layout = "us";
      variant = "intl";
      options = "caps:swapescape";
    };
    tty = {
      layout = "us";
    };
  };

  #controllers.enable = true;
  #packaging.flatpak.enable = true;
  gaming = {
    enable = true;
    steam = true;
  };

  #typeface = {
  #  enable = true;
  #  default = {
  #    gui = {
  #      general = "...";
  #      terminal = "...";
  #    };
  #    tty = "Lat2-Terminus16";
  #  };
  #};

  audio.enable = true; # TODO make default user module with 'mkForce'd options

  network = {
    enable = true;
    #interfaces = [ "enp2s0" "wlp3s0" ];
    sshServer = true;
  };

  bluetooth.enable = true;

  printer = {
    enable = true;
    drivers = with pkgs; [ epson-escpr ];
  };

  variables = {
    enable = true;
    definitions = { };
  };

  packages = {
    enable = true;
    design = true;
    extra = [ ];
  };

  permissions = {
    enable = true;
    users = {
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
}
