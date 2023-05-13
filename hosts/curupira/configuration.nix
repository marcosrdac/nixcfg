{ config, pkgs, ... }:

{

  host = {
    name = "curupira";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "aarch64-linux";
    nixos = "22.11";
  };

  imports = [
    ./oci
    ./hardware-configuration.nix
    ./nginx
    ./nextcloud
    ./gitea
    ./jellyfin
  ];

  booting = {
    enable = true;
    tmpOnTmpfs = false;
  };

  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  variables.enable = true;

  network = {
    enable = true;
    firewall.enable = true;
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
  };

  permissions = let
    keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyE8BXmo1HyfIH7mV1zomaZenHOUrS1kirvkTSN7elr2UZUqFFaYLZO896AiZtagHvR7MI4NVjIkEDQYVOHuzCp86RNE2Q6r8uuPAIzxDTJtvh/m9MYERzyr9FMrpnH4p4MAkVrtZEq28+2jid8ALdChstWwElIYtqvWunvs1nBoMkXanX8pmIt2IVbZ7po5iU/pJBK80OBEPZXuRW013jWiUibAyUWKtMn44HpxQzD/g+MbYDaG3lnB1u+IGXSkzDBlSGJmlPjz0qDF9oe093G//sTtnWqVdgcFrDoGtE2RG8DapNre61Du4HEatWNl0hlSD9yEO8fof4N4tYn1LgxNnVVuWuIN0NlYkPQCZfmPB1i/ye1iILxqMq9MT1U2DDW6PiCycngsa92LzsKF6YvRJ6gv4QF8Ma93Dlo30JBZ1HK5q/P9MxpzOfpkoEkKbGF1nCAF8DUyrVqxoCkANTjb1MVvGScDALQ3vAhT1f5mGAmsNBMrtTZ6Q8xVSobxEslAL3PPdzLimEblZOAQ70dBXMWGRGCsaG/e506dD8x0bDozT5LFUN5Lt5mK5QUYW+OPSeBkkb6VUNk17DkyH/20j/nopGJQTFmciG3xHSQsQfWFMrzotgM9SB0eu9SUpFVa4zunzw46oS1p9mVaOQt9jQ4ImWITdVAX+Q0KTKxQ== marcosrdac@gmail.com"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDHv+Cjw/hWRBQAkRy+HCu+HIyVLGEl16QsvxbVjl3HJXTh1sfIm27yUwyJLD19y/QR4J10pmMhKox/vyBOLCNzzC1IhzL71bI48/Zjak88Nq5lIhlld+I7Km4x8/A5wsX5w+Pg3OkFBvgJHjGjVl5rEiiIgYUxacaEzBcOpdm08Zqai64AAgnBVBXGYGU4VylhFFNTvKkPL0UTqwmgf1a6ENKgO1mkUa9pHgWtb1p4JTbfViJQyvL98PDSlVDs3TqChQ++WilHgIPUCDHW0Ura6GZwX18D06/oP0qpBmcyQHhLZ6yPoE6bwl+jgsX7As2OM9wQe9BuJLMfVR2aIzvCUoehT1zJ2ABTaOM5nTzZY0nHrSWQls55hBR1Rr5yxaHmy4buJ0XEpTBKVtw7axMYtqJTJN21MCwy5iFj9KeGNHVux6KUsq8SBz2clQlnZiA8XhrQ2zYMFNIH4J7TERGFdT5hKNaHAWq7gn6TYnZeFRzYK6zu/Ihc+LSIiS3agcNGDVqdUXn4eZLbjNyauZhVPVT5xuTWEtPa518tz+coYwry7DwmKrCJpMY9XvuMVrhk+SD0UH1aPbP1b9Un7/GWtlUjn5lEdZlaKfOHpHsH2Pbh6Zx5ZIRa/J4pv7Ryg5Bp2PF41Ha5h8MBRVUstsu+BvpXnP6WZGxv73GK3XEQw== marcosrdac@bennu"
    ];
  in {
    users = {
      root = {
        description = "root";
        isNormalUser = false;
        openssh.authorizedKeys.keys = keys;
      };
      marcosrdac = {
        description = "marcosrdac";
        isNormalUser = true;
        openssh.authorizedKeys.keys = keys;
      };
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.1" 
      "8.8.8.8"
    ];
  };

  packages = {
    list = with pkgs; [
      lf
      vim
      neovim
      wget
      git
      screen
      rclone
      ripgrep  # should be always installed; basic
      htop  # should be always installed; basic
      #imagemagick
      #ffmpeg
      #openiscsi
    ];
  };

}
