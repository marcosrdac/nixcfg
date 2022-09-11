{ config, pkgs, ... }:

let
  baseDir = "/mnt/nextcloud";
  nextcloudDir = "${baseDir}/root";
  passDir = "/mnt/pass/nextcloud";
  subdomain = "nextcloud.marcosrdac.com";
  extraSubdomains = [ "132.226.242.130" "cloud.marcosrdac.com" ];
in {
  # TODO correct permissions for pass dirs

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud24;

    #nginx.enable = true;
    #hostName = "localhost";
    hostName = subdomain;

    home = nextcloudDir;
    #datadir = nextcloudDir;

    autoUpdateApps = {
      enable = true;
      startAt = "Sat 3:00:00";
    };

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
  };

  services.postgresql = {
    enable = true;

    # Ensure the database, user, and permissions always exist
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

  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    # Setup Nextcloud virtual host to listen on ports
    virtualHosts = {
      ${subdomain} = {
        ## Force HTTP redirect to HTTPS
        forceSSL = true;
        ## LetsEncrypt
        enableACME = true;

        #locations."~ ^\/(?:index|apc|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy|.+\/richdocumentscode_arm64\/proxy|)\.php(?:$|\/)".extraConfig = ''
        #  fastcgi_split_path_info ^(.+?\.php)(\/.*|)$;
        #  set $path_info $fastcgi_path_info;
        #  try_files $fastcgi_script_name =404;
        #  include fastcgi_params;
        #  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        #  fastcgi_param PATH_INFO $path_info;
        #  fastcgi_param HTTPS on;
        #  # Avoid sending the security headers twice
        #  fastcgi_param modHeadersAvailable true;
        #  # Enable pretty urls
        #  fastcgi_param front_controller_active true;
        #  fastcgi_pass php-handler;
        #  fastcgi_intercept_errors on;
        #  fastcgi_request_buffering off;
        #'';

        # (
        # Not related to this config
        #root = "/var/www/blog";
        #locations."~ \.php$".extraConfig = ''
        #  fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
        #  fastcgi_index index.php;
        #'';
        # )

      };
    };

    #virtualHosts = {
    #  "cloud.marcosrdac.com" = {
    #    ## Force HTTP redirect to HTTPS
    #    forceSSL = true;
    #    ## LetsEncrypt
    #    enableACME = true;
    #   };
    # };
  };

}
