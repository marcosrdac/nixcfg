{ config, pkgs, ... }:

{

  # boot stuff
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
    };
  };

  # boot stuff end

  #booting = {
  #  enable = true;
  #  efi.enable = true;

  #  portable.enable = false;

  #  portable.efiSysMountPoint = "/boot";
  #  #portable.efiSysMountPoint = "/boot/EFI";
  ##  #tmp.useTmpfs = true;
  ##  #tmp.tmpfsSize = "2G";
  ##  runtimeDirectorySize = "1G";
  ##  useOSProber = false;
  #};

  #boot.loader.systemd-boot.enable = false;

  # add_windows_at flag
  boot.loader.grub.extraEntries = ''
    menuentry "Windows" {
      insmod part_gpt
      insmod fat
      insmod search_fs_uuid
      insmod chain
      search --fs-uuid --set=root 463F-EE6F
      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
  '';

  host = {
    name = "hydra";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.05";
  };

  imports = [ 
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_6_13;  # needed for 570.153.02, I believe
  #boot.kernelPackages = pkgs.linuxPackages_6_15;
  #boot.kernelPackages = pkgs.linuxPackages_6_14;

  # GeForce RTX 3050 Mobile
  # NVIDIA GeForce RTX 3050 Laptop GPU	
  # NVIDIA GeForce RTX 3050 4GB Laptop GPU	
  graphics.nvidia = {
    enable = true;
    open = true;
    driver = config.boot.kernelPackages.nvidiaPackages.stable;
    #driver = config.boot.kernelPackages.nvidiaPackages.beta;
    #driver = config.boot.kernelPackages.nvidia_x11;
    #driver = config.boot.kernelPackages.nvidia_x11_beta;
    prime = {
      sync.enable = true;
      #offload.enable = true;

      # offloading seems to work: new alacritties show no vram usage increase
      #sync.enable = false;
      #offload.enable = true;
      ##offload.enableOffloadCmd = true;

      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  boot.kernelParams = [ "i915.force_probe=a7a0" ];


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

  ##packaging.flatpak.enable = true;
  #gaming = {
  #  enable = true;
  #  steam = true;
  #};

  #typeface = {
  #  enable = true;
  ##  default = {
  ##    gui = {
  ##      general = "...";
  ##      terminal = "...";
  ##    };
  ##    tty = "Lat2-Terminus16";
  ##  };
  #};

  ## TODO make default user module with 'mkForce'd options (of just this kind of settings set used)
  ## this would be useful for non-servers
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
    list = with pkgs; [
      polkit  # UHK
    ];
  };

  permissions = {
    enable = true;
    users = {
      marcosrdac = {
        description = "Marcos Conceição";
        isNormalUser = true;
        extraGroups = [
          "nixcfg" "wheel" "docker" "vboxusers"
          # UHK tests
          "input" "dialout"
        ];
      };
      guest = {
        description = "Guest";
        isNormalUser = true;
      };
    };
    defaultGroups = [ "networkmanager" "lp" ];
  };

  services.udev.extraRules = ''
    # Ultimate Hacking Keyboard rules
    # These are the udev rules for accessing the USB interfaces of the UHK as non-root users.
    # Copy this file to /etc/udev/rules.d and physically reconnect the UHK afterwards.
    SUBSYSTEM=="input", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"

    SUBSYSTEM=="input", ATTRS{idVendor}=="37a8", ATTRS{idProduct}=="*", GROUP="input", MODE="0660"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="37a8", ATTRS{idProduct}=="*", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="37a8", ATTRS{idProduct}=="*", TAG+="uaccess"

    # UHK test extra
    SUBSYSTEM=="tty", ATTRS{idVendor}=="37a8", MODE="0660", TAG+="uaccess", GROUP="dialout"
  '';

  ### wayland (needed for sway)
  ### UHK also needs
  security.polkit.enable = true;
  services.dbus.enable = true;

  # building aarch-64 stuff
  #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  ### miracast
  ##networking.firewall.allowedTCPPorts = [7236 7250];
  ##networking.firewall.allowedUDPPorts = [7236 5353];

}
