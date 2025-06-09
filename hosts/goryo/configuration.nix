{ config, pkgs, ... }:

{

  boot.loader.systemd-boot.enable = false;

  host = {
    name = "goryo";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.05";
  };

  imports = [ 
    ./hardware-configuration.nix
  ];

  booting = {
    enable = true;
    efi.enable = true;
    tmpOnTmpfs = true;
    tmpOnTmpfsSize = "2G";
    runtimeDirectorySize = "1G";
    useOSProber = false;
  };

  gui.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
    powerKeyOff = true;
  };

  virtualization = {
    docker = true;
  };

  #packaging.flatpak.enable = true;
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
    basic = true;
    design = true;
    list = with pkgs; [ ];
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

  # building aarch-64 stuff
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # wayland (needed for sway)
  security.polkit.enable = true;

  # miracast
  networking.firewall.allowedTCPPorts = [7236 7250];
  networking.firewall.allowedUDPPorts = [7236 5353];

}
