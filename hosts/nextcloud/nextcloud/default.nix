{ config, pkgs, ... }:

# mkdir -p /var/secret (+adding secrets)
# mkdir -p /mnt/nextcloud

let
  nextcloudDir = "/mnt/nextcloud";
  secretDir = "${nextcloudDir}/secret";
  domain = "marcosrdac.com";
  nextcloudDomain = "cloud.${domain}";
  nextcloudVersion = "24";
in {

  #imports = [
  #  ./collabora.nix
  #];

  services.nextcloud = {
    enable = true;
    #enable = false;
    package = pkgs."nextcloud${nextcloudVersion}";
    #package = pkgs.nextcloud25;  # TODO

    hostName = "${nextcloudDomain}";

    home = nextcloudDir;
    #datadir = nextcloudDir;

    config = {
      adminuser = "admin";
      adminpassFile = "${secretDir}/nextcloud-admin-user-secret";

      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";  # nextcloud will add /.s.PGSQL.5432 by itself
      dbpassFile = "${secretDir}/nextcloud-db-secret";
      #dbpassFile = "/var/nextcloud-db-pass";

      extraTrustedDomains = [ ];
      overwriteProtocol = "https";
      
      # amazon
      #objectstore.s3 = {
      #  enable = true;
      #  autocreate = false;
      #  region = "sa-east-1";
      #  bucket = "marcosrdac-elf-nextcloud";
      #  key = "AKIASFIEOOH55YRLKYWP";
      #  secretFile = "${secretDir}/nextcloud-s3-bucket-secret";
      #  # below are needed in some S3 implementations
      #  #hostname = null;
      #  #port = null;
      #  #useSsl = null;
      #  #usePathStyle = false;
      #};

      #objectstore.s3 = {
      #  enable = true;
      #  autocreate = false;
      #  hostname = "s3.us-east-1.wasabisys.com";
      #  key = "YEFDWC57DWE7GR3H5PXP";
      #  secretFile = "${secretDir}/wasabi-secret";
      #  region = "us-east-1";
      #  bucket = "marcosrdac-nextcloud";
      #  # below are needed in some S3 implementations
      #  #port = null;
      #  #useSsl = null;
      #  #usePathStyle = false;
      #};

      objectstore.s3 = {
        enable = true;
        autocreate = false;
        hostname = "a58550f515b19b9c48df59790ce73215.r2.cloudflarestorage.com";
        useSsl = true;
        key = "e716d78ff182bee428e594d7b46f0c87";
        secretFile = "${secretDir}/cloudflare-secret";
        region = "auto";
        bucket = "marcosrdac-nextcloud";
        # below are needed in some S3 implementations
        #port = null;
        #usePathStyle = false;
      };
      
    };

    #extraOptions = { }; # ???? not here

    enableImagemagick = false;

    extraAppsEnable = true;
    extraApps = {
      # Find them here:
      # https://apps.nextcloud.com/

      memories = pkgs.fetchNextcloudApp {
        name = "memories";
        sha256 = "sha256-5guRuc7R8xFjeCoqzFbUjImNgQbthEj6UzRzh/I8AIQ=";
        url = "https://github.com/pulsejet/memories/releases/download/v3.10.3/memories.tar.gz";
        version = "3.10.3";
      };

      #phonetrack = pkgs.fetchNextcloudApp {
      #  name = "phonetrack";
      #  sha256 = "0qf366vbahyl27p9mshfma1as4nvql6w75zy2zk5xwwbp343vsbc";
      #  url = "https://gitlab.com/eneiluj/phonetrack-oc/-/wikis/uploads/931aaaf8dca24bf31a7e169a83c17235/phonetrack-0.6.9.tar.gz";
      #  version = "0.6.9";
      #};

      # dashboard
      # files
      # memories
      # notes
      # deck
      # mail
      # keeweb
      # calendar
      # talk
      # element
      # collectives
      # polls
      # tables
      # cospend
      # appointments
      # maps
      # ncdownloader
      # money
      # tasks
      # activity
      # mediadc
      # phonetrack
      # timemanager       X
      # timetracker       X
      # Duplicate finder
      # news
      # photos
    };
    appstoreEnable = true;

    autoUpdateApps = {
      enable = true;
      startAt = "Sat 3:00:00";
    };

  };

  services.nginx.virtualHosts."${nextcloudDomain}" = {
    forceSSL = true;
    enableACME = true;
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
