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

  booting = {
    enable = true;
    efi.enable = true;
    tmpOnTmpfs = true;
    useOSProber = false;
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
    extra = with pkgs; [ ];
  };

  networking.networkmanager.plugins = with pkgs; lib.mkForce [
    networkmanager-pptp
    networkmanager-vpnc
  ];
  #networking.networkmanager.plugins = with pkgs; lib.mkForce [
    #networkmanager-pptp
    #networkmanager-fortisslvpn
    #networkmanager-iodine
    #networkmanager-l2tp
    #networkmanager-openconnect
    #networkmanager-openvpn
    #networkmanager-vpnc
    #networkmanager-sstp
  #];

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
