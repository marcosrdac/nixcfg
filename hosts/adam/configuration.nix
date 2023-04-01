{ config, pkgs, ... }:

{

  host = {
    name = "adam";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "21.11";
  };

  imports = [ 
    ./hardware-configuration.nix
  ];

  gui.enable = true;

  booting = {
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

  typeface = {
    enable = true;
    default = {
      gui = {
        general = "...";
        terminal = "...";
      };
      tty = "Lat2-Terminus16";
    };
  };

  #graphics.nvidia.enable = true;
  graphics.nvidia.enable = false;

  # TODO make default user module with 'mkForce'd options (of just this kind of settings set used)
  # this would be useful for non-servers
  audio.enable = true;
  encryption.gpg.enable = true;
  mounter.enable = true;
  pointer.enable = true;

  network = {
    enable = true;
    interfaces = [ "enp2s0" "wlp3s0" ];
    openssh.enable = true;
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
    design = true;
    list = [ ];
  };

  permissions = {
    enable = true;
    users = {
      marcosrdac = {
        description = "Marcos Conceição";
        isNormalUser = true;
        extraGroups = [ "nixcfg" "wheel" "docker" "vboxusers" ];
      };
      guest = {
        description = "Guest";
        isNormalUser = true;
      };
    };
    defaultGroups = [ "networkmanager" "lp" ];
  };

}
