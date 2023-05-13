{ pkgs, config, lib, ... }:

{
  users.users.gitea.uid = 998;
  users.groups.gitea.gid = 492;

  services.nginx.virtualHosts."git.marcosrdac.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:${toString(config.services.gitea.httpPort)}";
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      "git.marcosrdac.com".email = "mail@marcosrdac.com";
      #"drone.my-domain.tld".email = "foo@bar.com";
    };
  };

  services.postgresql.enable = true;
  services.postgresql = {
    authentication = ''
      local gitea all ident map=gitea-users
    '';
    identMap = ''
      gitea-users gitea gitea
    '';
  };

  sops.secrets."gitea/db/pass" = {
    sopsFile = ../secrets.yaml;
    owner = config.users.users.gitea.name;
  };

  services.gitea = {
    enable = true;
    user = "gitea";
    appName = "marcosrdac's git server";
    rootUrl = "https://git.marcosrdac.com/";
    domain = "git.marcosrdac.com";
    httpPort = 3001;
    stateDir = "/var/lib/gitea";
    database = {
      type = "postgres";
      passwordFile = config.sops.secrets."gitea/db/pass".path;
    };
    settings = {
      log.LEVEL = "Warn";
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
      server = {
        LANDING_PAGE = "explore";
        LFS_START_SERVER = true;
      };
      lfs.PATH = "/var/lib/gitea/data/lfs";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  virtualisation.docker = {
    enable = true;
  };

}
