{ config, pkgs, ... }:

let
  domain = "marcosrdac.com";
  domainRoot = "/var/www/${domain}";
in {

  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
      root = "${domainRoot}";
    };
    #"*.${domain}" = {
      #globalRedirect = "${domain}";
    #};
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  security.acme.certs = {
    "${domain}" = {
      email = "mail@marcosrdac.com";
    };
  };

}
