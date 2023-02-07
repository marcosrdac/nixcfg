{ config, pkgs, ... }:

let
  domain = "test.marcosrdac.com";
  domainRoot = "/var/www/${domain}";
in {

  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;

      # SSL configuration
      #addSSL = true;     # enables https (not needed at first)
      forceSSL = true;    # auto-redirect http -> https
      #onlySSL = true;    # do not allow http (5% confidence)
      #rejectSSL = true;  # do not allow https  (5% confidence)

      # remember everything must be nginx's (12% confidence)
      root = "${domainRoot}";
    };
  };

  networking.firewall = {
    enable = true;
    # reliable ports
    allowedTCPPorts = [ 80 443 ];
    # fast ports
    #allowedUDPPortRanges = [ { from = 4000; to = 4007; } { from = 8000; to = 8010; } ];
  };

  security.acme.certs = {
    "${domain}" = {
      email = "mail@marcosrdac.com";
    };
  };

}
