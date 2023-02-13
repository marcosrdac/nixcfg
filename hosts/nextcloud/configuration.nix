{ config, pkgs, modulesPath, ... }:

{

  host = builtins.trace {
    name = "nextcloud";
    zone = "US/Eastern";
    locale = "en_US.UTF-8";
    system = "aarch64-linux";
    nixos = "22.05";
  };

  ec2.hvm = true;
  ec2.efi = true;
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    #./nginx
    #./nextcloud
  ];

  booting = {
    enable = true;
    tmpOnTmpfs = false;
  };

  services.logind.extraConfig = ''
    RuntimeDirectorySize=2G
    RuntimeDirectoryInodesMax=1048576
  '';

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 20 ];
  };

  variables.enable = true;

  packages = {
    list = with pkgs; [
      #lf
      #vim
      #builtins.trace wget wget
      #git
      #screen
      #rclone
    ];
  };

}
