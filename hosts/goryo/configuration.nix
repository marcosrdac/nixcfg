{ config, pkgs, flakeDir, ... }:

{
  secrets = {
    enable = true;
  };

  sops = {
    age.keyFile = "/root/.config/sops/age/keys.txt";
    secrets = {
      "passwords/marcosrdac" = {
        sopsFile = "${flakeDir}/secrets/local.yaml";
        #sopsFile = /secrets/local.yaml;
        key = "passwords/marcosrdac";
        #optional = true;
        neededForUsers = true;
      };
      "passwords/test" = {
        #optional = true;
        sopsFile = ../../secrets/local.yaml;
        neededForUsers = true;
      };
    };
  };

  #users.users.marcosrdac.hashedPasswordFile = config.sops.secrets."passwords/marcosrdac".path;
  users.users.marcosrdac.hashedPasswordFile = "/run/secrets-for-users/passwords/marcosrdac";
  users.users.test.hashedPasswordFile = "/run/secrets-for-users/passwords/marcosrdac";

  #sops.secrets = {
  #  "global/test" = {
  #    sopsFile = ./global.yaml;
  #    owner = "root";
  #  };
  #  #"curupira/api_token" = {
  #  #  sopsFile = ./hosts/curupira/secrets.yaml;
  #  #  owner = "root";
  #  #};
  #  #"marcosrdac/personal_github_token" = {
  #  #  sopsFile = ./users/marcosrdac/secrets.yaml;
  #  #  owner = config.users.users.marcosrdac.name;
  #  #};
  #  #"marcosrdac/curupira/wireguard_key" = {
  #  #  sopsFile = ./users/marcosrdac/hosts/curupira/secrets.yaml;
  #  #  owner = config.users.users.marcosrdac.name;
  #  #};
  #};  

  # ---

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  services.xserver.videoDrivers = [
    "i915"
    "intel"
  ];
  services.thermald.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
      intel-vaapi-driver
      mesa
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # ---

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
    tmp = {
      useTmpfs = true;
      tmpfsSize = "2G";
    };
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
    enable = false;
  #  enable = true;
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
      test = {
        description = "Test";
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
