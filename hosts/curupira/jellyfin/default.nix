{ pkgs, config, lib, ... }:

{

  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
 
  users.groups.media.gid = 481;

  services.nginx.virtualHosts."media.marcosrdac.com" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        extraConfig = ''
          proxy_buffering off;
        '';
        proxyPass = "http://127.0.0.1:8096";
      };
      "/socket" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      "media.marcosrdac.com".email = "mail@marcosrdac.com";
    };
  };

  services = {
    bazarr = {
      enable = true;
      group = "media";
      #openFirewall = true;
    };
    lidarr = {
      enable = true;
      group = "media";
      #openFirewall = true;
    };
    radarr = {
      enable = true;
      group = "media";
      #openFirewall = true;
    };
    sonarr = {
      enable = true;
      group = "media";
      #openFirewall = true;
    };
    jackett = {
      enable = true;
      group = "media";
      #openFirewall = true;
    };
  };

  users.users.bazarr.extraGroups = [ "transmission" ];
  users.users.lidarr.extraGroups = [ "transmission" ];
  users.users.radarr.extraGroups = [ "transmission" ];
  users.users.sonarr.extraGroups = [ "transmission" ];

  services.nginx.virtualHosts = {
    #"bazarr.marcosrdac.com" = {
      #enableACME = true;
      #forceSSL = true;
      #locations."/".proxyPass = "http://127.0.0.1:6767";
    #};

    #"lidarr.marcosrdac.com" = {
      #enableACME = true;
      #forceSSL = true;
      #locations."/".proxyPass = "http://127.0.0.1:8686";
    #};

    #"radarr.marcosrdac.com" = {
      #enableACME = true;
      #forceSSL = true;
      #locations."/".proxyPass = "http://127.0.0.1:7878";
    #};

    #"sonarr.marcosrdac.com" = {
      #enableACME = true;
      #forceSSL = true;
      #locations."/".proxyPass = "http://127.0.0.1:8989";
    #};

    #"jackett.marcosrdac.com" = {
      #enableACME = true;
      #forceSSL = true;
      #locations."/".proxyPass = "http://127.0.0.1:9117";
    #};
  };

  services.transmission = {
    enable = true;
  };

}
