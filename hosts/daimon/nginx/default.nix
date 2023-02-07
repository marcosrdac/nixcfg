{ config, pkgs, ... }:

{

  imports = [
    ./marcosrdac.com.nix
    ./test.marcosrdac.com.nix
  ];

  services.nginx = {
    enable = true;
    user = "nginx";

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "mail@marcosrdac.com";
  };

  #systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
  #systemd.services.nginx.serviceConfig.ReadOnlyPaths = [ "/home/" "/root/" "/root/t" ];
  #systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/root/t" ];

}
