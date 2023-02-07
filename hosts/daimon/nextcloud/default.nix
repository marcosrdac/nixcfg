{ config, pkgs, ... }:

let
  baseDir = "/mnt/nextcloud";
  nextcloudDir = "${baseDir}/root";
  passDir = "/mnt/pass/nextcloud";
  domain = "marcosrdac.com";
  extraSubdomains = [ "cloud.marcosrdac.com" ];
in {

  #imports = [
  #  ./collabora.nix
  #];

  services.nginx.virtualHosts."nextcloud.${domain}" = {
    forceSSL = true;
    enableACME = true;
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud24;
    #package = pkgs.nextcloud25;  # TODO

    #nginx.enable = true;
    #hostName = "localhost";
    hostName = "nextcloud.${domain}";

    home = nextcloudDir;
    #datadir = nextcloudDir;

    config = {
      adminuser = "admin";
      adminpassFile = "${passDir}/admin";

      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbpassFile = "${passDir}/db";
      #dbpassFile = "/var/nextcloud-db-pass";

      extraTrustedDomains = extraSubdomains;
      overwriteProtocol = "https";

      #https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/nextcloud.nix
    };

    #objetctstorage.s3 = {
    #  enable = true;
    #  bucket = "marcosrdac-daimon-nextcloud";
    #  autocreate = false;
    #  key = "KEY";
    #};

    extraAppsEnable = true;
    extraApps = {
      #maps = pkgs.fetchNextcloudApp {
      #  name = "maps";
      #  sha256 = "007y80idqg6b6zk6kjxg4vgw0z8fsxs9lajnv49vv1zjy6jx2i1i";
      #  url = "https://github.com/nextcloud/maps/releases/download/v0.1.9/maps-0.1.9.tar.gz";
      #  version = "0.1.9";
      #};
      #phonetrack = pkgs.fetchNextcloudApp {
      #  name = "phonetrack";
      #  sha256 = "0qf366vbahyl27p9mshfma1as4nvql6w75zy2zk5xwwbp343vsbc";
      #  url = "https://gitlab.com/eneiluj/phonetrack-oc/-/wikis/uploads/931aaaf8dca24bf31a7e169a83c17235/phonetrack-0.6.9.tar.gz";
      #  version = "0.6.9";
      #};
    };
    appstoreEnable = true;

    autoUpdateApps = {
      enable = true;
      startAt = "Sat 3:00:00";
    };

  };

  services.postgresql = {
    enable = true;
    # Ensure the database, user and permissions always exist
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  #virtualisation.oci-containers = {
  #  backend = "docker";
  #  containers = {
  #    collabora = {
  #      image = "collabora/code:22.05.10.1.1";
  #      #image = "collabora/code:latest";
  #      #host_port:container_port
  #      #ports = [ "443:9980" ];
  #      #ports = [ "9980:9980" ];
  #      ports = [ "9980:9980" ];
  #      environment = {
  #        username = "admin";
  #        password = "${passDir}/collabora";
  #        dictionaries = "en_US,pt-br";
  #        domain = "collabora.${domain}";
  #        extra_params = "--o:ssl.enable=false";
  #      };
  #    };
  #    #onlyoffice = {
  #    #  image = "onlyoffice/documentserver";
  #    #  ports = [ "9981:80" ];
  #    #};
  #  };
  #};
}
