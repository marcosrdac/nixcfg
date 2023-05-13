{ config, pkgs, lib, ... }:

with lib; let
  domain = "marcosrdac.com";
  nextcloudDomain = "cloud.${domain}";
  collaboraDomain = "collabora.${domain}";
  onlyofficeDomain = "office.${domain}";
  nextcloudVersion = "25";
  nextcloudDir = "/mnt/nextcloud";
  nextcloudSecretDir = "${nextcloudDir}/secret";
  nextcloudDataDir = "${nextcloudDir}/data";
  rcloneConfigFile = "${nextcloudSecretDir}/rclone.conf";
  # better than wasabi before 1TB data for personal use
  #rcloneBucket = "backblaze-crypted:marcosrdac-curupira-nextcloud-data";
  rcloneBucket = "wasabi-crypted:marcosrdac-curupira-nextcloud-data";
  # got me some rcp errors
  #rcloneBucket = "storj:marcosrdac-curupira-nextcloud-data";
  rcloneCacheDir = "${nextcloudDir}/cache";
  #enable = false;
  enable = true;
  #enable = false;
  enableCollabora = false;
in {

  imports = [
    ./module.nix
  ];

  environment.systemPackages = with pkgs; [ python3 ffmpeg ];

  users.users.nextcloud.uid = 800;
  users.users.nextcloud.group = "nextcloud";
  users.users.nextcloud.isSystemUser = true;
  users.groups.nextcloud.gid = 801;

  services.myNextcloud = {
    enable = enable;
    package = pkgs."nextcloud${nextcloudVersion}";

    hostName = "${nextcloudDomain}";

    home = nextcloudDir;         # inside: apps, store-apps, nix-apps
    datadir = nextcloudDir;      # inside: config
    truedatadir = nextcloudDataDir;  # actual user data folder

    https = true;

    appstoreEnable = true;
    extraAppsEnable = true;
    extraApps = { };

    autoUpdateApps = {
      enable = true;
      startAt = "Sat 3:00:00";
    };

    enableImagemagick = true;

    config = {
      adminuser = "admin";
      adminpassFile = "${nextcloudSecretDir}/nextcloud-admin-secret";

      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";  # nextcloud will add /.s.PGSQL.5432 by itself
      dbpassFile = "${nextcloudSecretDir}/nextcloud-db-secret";

      extraTrustedDomains = [ ];
      defaultPhoneRegion = "BR";
      overwriteProtocol = "https";
    };

  };

  services.nginx.virtualHosts."${nextcloudDomain}" = {
    forceSSL = true;
    enableACME = true;
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions = {
          "DATABASE nextcloud" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" "nextcloud-data-mount.service" ];
    after = [ "postgresql.service" "nextcloud-data-mount.service" ];
  };

  environment.etc."fuse.conf".text = ''
    user_allow_other
  '';

  security.wrappers = {
    fusermount.source  = "${pkgs.fuse}/bin/fusermount";
  };

  systemd.services.nextcloud-data-mount = {
    enable = true;
    #enable = false;
    #enable = enable;
    description =  "mount nextcloud data dir";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      #User = "nextcloud";  # could not run fusermount as user
      Group = "nextcloud";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${nextcloudDataDir}";
      ExecStart = with builtins; ''
        ${pkgs.rclone}/bin/rclone mount ${rcloneBucket} ${nextcloudDataDir} \
          --config "${rcloneConfigFile}" \
          --cache-dir "${rcloneCacheDir}" \
          --vfs-cache-mode full \
          --vfs-read-chunk-size 10M \
          --vfs-cache-max-age 48h \
          --vfs-cache-max-size 15G \
          --dir-cache-time 24h \
          --transfers 4 \
          --uid ${toString config.users.users.nextcloud.uid} \
          --gid ${toString config.users.groups.nextcloud.gid} \
          --file-perms 0770 \
          --dir-perms 0660 \
          --buffer-size 512M \
          --attr-timeout 1s \
          --umask 002 \
          --allow-other
      '';
          #--umask 002 \
          # --log-level INFO --log-file ~/rclone.log
      ExecStop = ''
        ${pkgs.fuse}/bin/fusermount -u ${nextcloudDataDir}
      '';
      Type = "notify";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    };
  };

  #services.onlyoffice = {
    #enable = true;
    #hostname = onlyofficeDomain;
  #};

  virtualisation.oci-containers = {
    backend = "podman";
    #backend = "docker";
    containers = {
      onlyoffice = {
        image = "onlyoffice/documentserver";
        ports = [ "9981:80" ];
      };
    };
  };

  services.nginx.virtualHosts.${onlyofficeDomain}.listen = [ { addr = "127.0.0.1"; port = 9981; } ];

  #virtualisation.oci-containers = mkIf enableCollabora {
  #  #backend = "podman";
  #  backend = "docker";
  #  containers = {
  #    collabora = {
  #      image = "collabora/code:22.05.10.1.1";
  #      #image = "collabora/code:latest";
  #      #host_port:container_port
  #      #ports = [ "9980:9980" ];
  #      ports = [ "127.0.0.1:9980:9980" ];
  #      environment = {
  #        username = "admin";
  #        password = "${nextcloudSecretDir}/collabora-secret";
  #        dictionaries = "en_US";
  #        #domain = nextcloudDomain;
  #        #server_name = collaboraDomain;
  #        domain = "cloud\\.marcosrdac\\.com";
  #        server_name = "collabora\\.marcosrdac\\.com";
  #        #extra_params = "--o:ssl.enable=true";
  #        #extra_params = "--o:ssl.enable=false";
  #      };
  #      #extraOptions = [ "--cap-add=MKNOD" ];
  #      extraOptions = [ "--cap-add=MKNOD" ];
  #    };

  #    #onlyoffice = {
  #    #  image = "onlyoffice/documentserver";
  #    #  ports = [ "9981:80" ];
  #    #};

  #  };
  #};

  #services.nginx.virtualHosts."${collaboraDomain}" = mkIf enableCollabora {
  #  #forceSSL = true;
  #  addSSL = true;
  #  enableACME = true;

  #  locations = {

  #    # static files
  #    "^~ /browser" = {
  #      "proxyPass" = "https://127.0.0.1:9980";
  #      extraConfig = ''
  #        proxy_set_header Host $host;
  #      '';
  #    };
  #    "^~ /loleaftlet" = {
  #      "proxyPass" = "https://127.0.0.1:9980";
  #      extraConfig = ''
  #        proxy_set_header Host $host;
  #      '';
  #    };

  #    # WOPI discovery URL
  #    "^~ /hosting/discovery" = {
  #      "proxyPass" = "https://127.0.0.1:9980";
  #      extraConfig = ''
  #        proxy_set_header Host $host;
  #      '';
  #    };

  #    # Capabilities
  #    "^~ /hosting/capabilities" = {
  #      "proxyPass" = "https://127.0.0.1:9980";
  #      extraConfig = ''
  #        proxy_set_header Host $host;
  #        proxy_read_timeout 36000s;
  #      ''; # above line is new
  #    };

  #    # main websocket
  #    "~ ^/cool/(.*)/ws$" = {
  #      "proxyPass" = "https://127.0.0.1:9980";
  #      extraConfig = ''
  #        proxy_set_header Upgrade $http_upgrade;
  #        proxy_set_header Connection "Upgrade";
  #        proxy_set_header Host $host;
  #        proxy_read_timeout 36000s;
  #      '';
  #    };

  #    # download, presentation and image upload
  #    "~ ^/(c|l)ool" = {
  #      "proxyPass" = "https://127.0.0.1:9980";
  #      extraConfig = ''
  #        proxy_set_header Host $host;
  #      '';
  #    };

  #    # Admin Console websocket
  #    "^~ /cool/adminws" = {
  #      "proxyPass" = "https://127.0.0.1:9980";
  #      extraConfig = ''
  #        proxy_set_header Upgrade $http_upgrade;
  #        proxy_set_header Connection "Upgrade";
  #        proxy_set_header Host $host;
  #        proxy_read_timeout 36000s;
  #      '';
  #    };

  #  };

  #};

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

}
