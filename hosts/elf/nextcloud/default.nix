{ config, pkgs, ... }:

# mkdir -p /var/secret (+adding secrets)
# mkdir -p /mnt/nextcloud

let
  nextcloudDir = "/mnt/nextcloud/data";
  secretDir = "/var/secret";
  domain = "marcosrdac.com";
  nextcloudSubdomain = "cloud.${domain}";
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

    hostName = "${nextcloudSubdomain}";

    home = nextcloudDir;
    #datadir = nextcloudDir;

    config = {
      adminuser = "admin";
      adminpassFile = "${secretDir}/nextcloud-admin-user-secret";

      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbpassFile = "${secretDir}/nextcloud-db-secret";
      #dbpassFile = "/var/nextcloud-db-pass";

      extraTrustedDomains = [ ];
      overwriteProtocol = "https";

      #https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/nextcloud.nix
    };

    objectstore.s3 = {
      enable = true;
      bucket = "marcosrdac-elf-nextcloud";
      autocreate = false;
      key = "AKIASFIEOOH5Z2NDDP7C";
      secretFile = "${secretDir}/nextcloud-s3-bucket-secret";
      # below are needed in some S3 implementations
      hostname = null;
      port = null;
      useSsl = null;
      region = null;
      usePathStyle = false;
    };

    enableImagemagick = false;
    extraOptions = { };

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

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
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

}
