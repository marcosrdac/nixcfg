{ config, pkgs, ... }:

{

  #systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
  #systemd.services.nginx.serviceConfig.ReadOnlyPaths = [ "/home/" "/root/" "/root/t" ];
  #systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/root/t" ];

  networking.firewall = {
    enable = true;
    # maybe move 8080 and 4443 to nextcloud's config
    allowedTCPPorts = [ 80 443 8080 4443 9980 ];
    #allowedUDPPortRanges = [
    #  { from = 4000; to = 4007; }
    #  { from = 8000; to = 8010; }
    #];
  };

  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    user = "nginx";
    virtualHosts = {
      "t.marcosrdac.com" = {
        enableACME = true;
        addSSL = true;
        #forceSSL = true;
        #root = "/root/t";
        root = "/var/www/t";
      };
      "blog.marcosrdac.com" = {
        enableACME = true;
        addSSL = true;
        #forceSSL = true;
        #root = "/root/t";
        root = "/var/www/t";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "mail@marcosrdac.com";
    certs = {
      "t.marcosrdac.com" = {
        #email = "mail@marcosrdac.com";
        #listenHTTP = ":80";
        #group = "nginx";
      };
      "blog.marcosrdac.com" = {
        #email = "mail@marcosrdac.com";
        #listenHTTP = ":80";
        #group = "nginx";
      };
    };
  };

}
