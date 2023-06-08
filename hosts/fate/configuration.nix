{ config, pkgs, ... }:

{

  host = {
    name = "fate";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.11";
  };

  services.xserver.xrandrHeads = [
    {
      output = "HDMI-A-1-1";
      primary = false;  
      monitorConfig = "Option \"Rotate\" \"left\"";
    }
    { output = "HDMI-0"; primary = true; }
  ];

  services.xserver.wacom.enable = true;
  #hardware.opentabletdriver.enable = true;

  #services.xserver.displayManager.setupCommands = ''
  #  ${pkgs.xorg.xrandr}/bin/xrandr --output "HDMI-A-1-1" --left-of HDMI-0
  #'';

  # allow building for aarch64-linux
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
    #useOSProber = true;
  };

  ##boot.tmpOnTmpfs = cfg.boot.tmpOnTmpfs;
  ##boot.cleanTmpDir = !cfg.boot.tmpOnTmpfs;

  boot.tmpOnTmpfs = true;
  boot.cleanTmpDir = false;
  boot.tmpOnTmpfsSize = "180%";

  #services.logind.extraConfig = ''
    #RuntimeDirectorySize=20G
    #RuntimeDirectoryInodesMax=1048576  
  #'';

  ### graphics
  gui.enable = true;

  services.xserver.desktopManager.gnome.enable = true;

  # need linux kernel>=6.0 for my RTX 4090
  boot.kernelPackages = pkgs.linuxPackages_latest;
  graphics.nvidia = {
    enable = true;
    #driver = config.boot.kernelPackages.nvidiaPackages.stable;
    driver = config.boot.kernelPackages.nvidiaPackages.beta;
    #driver = config.boot.kernelPackages.nvidia_x11;
    #driver = config.boot.kernelPackages.nvidia_x11_beta;
    prime = {
      sync.enable = true;
      #offload.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:107:0:0";
    };
  };

  virtualization = {
    docker = true;
    podman = true;
  };

  #keyboard = {
  #  enable = true;
  #  gui = {
  #    layout = "us";
  #    variant = "intl";
  #    options = "caps:swapescape";
  #  };
  #  tty = {
  #    layout = "us";
  #  };
  #};

  ##controllers.enable = true;
  packaging.flatpak.enable = true;
  gaming = {
    enable = true;
    steam = true;
  };

  typeface = {
    #enable = true;
    #default = {
    #  gui = {
    #    general = "...";
    #    terminal = "...";
    #  };
    #  tty = "Lat2-Terminus16";
    #};
  };

  ## TODO make default user module with 'mkForce'd options (of just this kind of settings set used)
  ## this would be useful for non-servers
  audio.enable = true;
  encryption.gpg.enable = true;
  mounter.enable = true;
  pointer.enable = true;

  network = {
    enable = true;
    #interfaces = [ "enp2s0" "wlp3s0" ];
    openssh = {
      enable = true;
    };
  };

  #bluetooth.enable = true;

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
        uid = 1001;
        description = "Marcos Conceição";
        isNormalUser = true;
        extraGroups = [ "nixcfg" "hdd" "wheel" "docker" "vboxusers" ];
      };
      guest = {
        description = "Guest";
        isNormalUser = true;
      };
    };
    defaultGroups = [ "networkmanager" "lp" ];
  };

  users.groups.hdd.gid = 700;

  sops.secrets.my-password-key = {
    mode = "0440";
    owner = config.users.users.marcosrdac.name;
    group = config.users.users.marcosrdac.group;
    path = "/home/marcosrdac/test";
  };

  users.groups.plugdev.gid = 750;

  users.users.marcosrdac.extraGroups = [
    config.users.groups.keys.name
    config.users.groups.plugdev.name
  ];

  services.udev.extraRules = ''
    # Rules for Oryx web flashing and live training
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

    # Legacy rules for live training over webusb (Not needed for firmware v21+)
      # Rule for all ZSA keyboards
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
      # Rule for the Moonlander
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
      # Rule for the Ergodox EZ
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
      # Rule for the Planck EZ
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

    # Wally Flashing rules for the Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

    # Wally Flashing rules for the Moonlander and Planck EZ
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11",     MODE:="0666",     SYMLINK+="stm32_dfu"
    Note: The snippet above defines rules for all ZSA's keyboards. Feel free to only copy the block relevant to you.
  '';


  sops.defaultSopsFile = ./secrets.yaml;
  ## This will automatically import SSH keys as age keys
  #sops.age.sshKeyPaths = [
    #"/etc/ssh/ssh_host_ed25519_key"
  #];
  ## This is using an age key that is expected to already be in the filesystem
  #sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  ## This will generate a new key if the key specified above does not exist
  #sops.age.generateKey = true;
  ## This is the actual specification of the secrets.
  #sops.secrets.example-key = {};
  #sops.secrets."myservice/my_subdir/my_secret" = {};

}
