{ config, pkgs, ... }:

{
  # building aarch-64 stuff
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  host = {
    name = "bennu";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.05";
  };

  environment.etc = {
    "resolv.conf".text = ''
      nameserver 8.8.8.8
      nameserver 8.8.4.4
    '';
  };

  imports = [ 
    ./hardware-configuration.nix
  ];

  booting = {
    enable = true;
    efi.enable = true;
    tmpOnTmpfs = true;
    useOSProber = false;
  };

  #boot.tmpOnTmpfs = cfg.boot.tmpOnTmpfs;
  #boot.cleanTmpDir = !cfg.boot.tmpOnTmpfs;

  boot.tmpOnTmpfs = true;
  boot.cleanTmpDir = false;
  boot.tmpOnTmpfsSize = "180%";

  services.logind.extraConfig = ''
    RuntimeDirectorySize=20G
    RuntimeDirectoryInodesMax=1048576  
  '';

  gui.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  graphics.nvidia.enable = true;

  virtualization = {
    docker = true;
    podman = true;
  };

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
  packaging.flatpak.enable = true;
  gaming = {
    enable = true;
    steam = true;
  };

  typeface = {
    enable = true;
  #  default = {
  #    gui = {
  #      general = "...";
  #      terminal = "...";
  #    };
  #    tty = "Lat2-Terminus16";
  #  };
  };

  # TODO make default user module with 'mkForce'd options (of just this kind of settings set used)
  # this would be useful for non-servers
  audio.enable = true;
  encryption.gpg.enable = true;
  mounter.enable = true;
  pointer.enable = true;

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
    basic = true;
    design = true;
    list = with pkgs; [ ];
  };

  networking.networkmanager.plugins = with pkgs; lib.mkForce [
    networkmanager-pptp
    networkmanager-vpnc
    networkmanager-fortisslvpn
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
