{ config, pkgs, lib, ... }:

# mkdir -p /var/secret (+adding secrets)
# mkdir -p /mnt/nextcloud

with lib; let
  domain = "marcosrdac.com";
  nextcloudDomain = "cloud.${domain}";
  nextcloudVersion = "25";
  nextcloudDir = "/mnt/nextcloud";
  nextcloudSecretDir = "${nextcloudDir}/secret";
  nextcloudDataDir = "${nextcloudDir}/data";
  rcloneConfigFile = "${nextcloudSecretDir}/rclone.conf";
  # better than wasabi before 1TB data
  rcloneBucket = "backblaze-crypted:marcosrdac-curupira-nextcloud-data";
  #rcloneBucket = "wasabi-crypted:marcosrdac-curupira-nextcloud-data";
  # got me some rcp errors
  #rcloneBucket = "storj:marcosrdac-curupira-nextcloud-data";
  rcloneCacheDir = "${nextcloudDir}/cache";
  enable = true;
  #enable = false;

  # FUTURE
  #systemd.services.nextcloud-data-mount = {
  #  enable = true;
  #  #enable = enable;
  #  description =  "mount nextcloud data dir";
  #  after = [ "network-online.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = makeRcloneMountServiceConfig {
  #    localDir = nextcloudDataDir;
  #    rcloneDir = rcloneDir;
  #    rcloneConfigFile = rcloneConfigFile;
  #    rcloneCacheDir = rcloneCacheDir;
  # };
  #};

  #makeRcloneMountServiceConfig = { localDir
  #                               , rcloneDir
  #                               , rcloneConfigFile
  #                               , rcloneCacheDir
  #                               #, mountAsUser = null
  #                               #, mountAsGroup = null
  #                             }:
  #{
  #  #User = "nextcloud";  # could not run fusermount as user
  #  Group = "nextcloud";
  #  ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${localDir}";
  #  ExecStart = with builtins; ''
  #    ${pkgs.rclone}/bin/rclone mount ${rcloneDir} ${localDir} \
  #      --config "${rcloneConfigFile}" \
  #      --cache-dir "${rcloneCacheDir}" \
  #      --vfs-cache-mode full \
  #      --vfs-read-chunk-size 10M \
  #      --vfs-cache-max-age 48h \
  #      --vfs-cache-max-size 15G \
  #      --dir-cache-time 24h \
  #      --transfers 4 \
  #      --uid ${toString config.users.users.nextcloud.uid} \
  #      --gid ${toString config.users.groups.nextcloud.gid} \
  #      --file-perms 0770 \
  #      --dir-perms 0660 \
  #      --buffer-size 512M \
  #      --attr-timeout 1s \
  #      --umask 002 \
  #      --allow-other
  #  '';
  #      # --log-level INFO --log-file ~/rclone.log
  #    ExecStop = ''
  #      ${pkgs.fuse}/bin/fusermount -u ${localDir}
  #    '';
  #  Type = "notify";
  #  Restart = "always";
  #  RestartSec = "10s";
  #  Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
  #};

in {

  imports = [
    ./module.nix
  ];

  #nixpkgs.config.allowUnsupportedSystem = true;

  environment.systemPackages = with pkgs; [
    ffmpeg
    #intel-media-driver # LIBVA_DRIVER_NAME=iHD
    #vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    #vaapiVdpau
    #libvdpau-va-gl
  ];

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

      #objectstore.s3 = {
      #  enable = true;
      #  autocreate = true;  # does not work with cloudflare
      #  hostname = "a58550f515b19b9c48df59790ce73215.r2.cloudflarestorage.com";
      #  key = "d7587effad1924543456b23860c822e5";
      #  secretFile = "${nextcloudSecretDir}/cloudflare-store-secret";
      #  region = "auto";
      #  bucket = "marcosrdac-curupira-nextcloud-data";
      #  # below options might be needed
      #  #useSsl = true;
      #  #port = null;
      #  #usePathStyle = false;
      #};

    };

  };

  services.nginx.virtualHosts."${nextcloudDomain}" = {
    forceSSL = true;
    enableACME = true;
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

  systemd.services.other-nextcloud-data-mount = {
    #enable = true;
    enable = false;
    #enable = enable;
    description =  "mount other nextcloud data dir";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = let
      rcloneDir = "backblaze-crypted:marcosrdac-curupira-nextcloud-data";
      localDir = "/mnt/tmp";
    in {
      #User = "nextcloud";  # could not run fusermount as user
      Group = "nextcloud";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${localDir}";
      ExecStart = with builtins; ''
        ${pkgs.rclone}/bin/rclone mount ${rcloneDir} ${localDir} \
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
          ${pkgs.fuse}/bin/fusermount -u ${localDir}
        '';
      Type = "notify";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
    };
  };

  #systemd.services.test-data-mount = {
  #  #enable = true;
  #  #enable = enable;
  #  description =  "mount test data dir";
  #  after = [ "network-online.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    #User = "nextcloud";  # could not run fusermount as user
  #    #Group = "nextcloud";
  #    #ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${nextcloudDataDir}";
  #    ExecStart = with builtins; ''
  #      ${pkgs.rclone}/bin/rclone mount storj:marcosrdac-curupira-nextcloud-data /root/mnt \
  #        --config "${rcloneConfigFile}" \
  #        --cache-dir "${rcloneCacheDir}" \
  #        --vfs-cache-mode full \
  #        --vfs-read-chunk-size 10M \
  #        --vfs-cache-max-age 48h \
  #        --vfs-cache-max-size 15G \
  #        --dir-cache-time 24h \
  #        --transfers 4 \
  #        --file-perms 0770 \
  #        --dir-perms 0660 \
  #        --buffer-size 512M \
  #        --attr-timeout 1s \
  #        --umask 002 \
  #        --allow-other
  #    '';
  #        #--umask 002 \
  #        # --log-level INFO --log-file ~/rclone.log
  #        # --uid ${config.users.users.nextcloud.uid} \
  #        # --gid ${config.users.groups.nextcloud.gid} \
  #        # --umask 0007 \
  #      ExecStop = ''
  #        ${pkgs.fuse}/bin/fusermount -u /root/mnt
  #      '';
  #    Type = "notify";
  #    Restart = "always";
  #    RestartSec = "10s";
  #    Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
  #  };
  #};

  users.users.nextcloud.uid = 800;
  #users.users.nextcloud.groups = 800;
  users.users.nextcloud.group = "nextcloud";
  users.users.nextcloud.isSystemUser = true;
  users.groups.nextcloud.gid = 801;

  #virtualisation.oci-containers = {
  #  backend = "podman";
  #  #backend = "docker";
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
  #        #domain = "collabora.${domain}";
  #        domain = "${nextcloudDomain}";
  #        server_name = "collabora.${domain}";
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

  #services.nginx.virtualHosts."collabora.${domain}" = {
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
