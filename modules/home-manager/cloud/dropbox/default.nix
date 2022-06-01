{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.cloud.dropbox;
in {

  options.cloud.dropbox = {
    enable = mkEnableOption "Dropbox daemon";

    linkPath = mkOption {
      description = "Where to link Dropbox data";
      type = types.path;
      default = "${config.home.sessionVariables.XDG_CLOUD_HOME}/dropbox";
      apply = toString;
    };

    truePath = mkOption {
      description = "Where to store Dropbox data and metadata";
      type = types.path;
      default = "${config.home.sessionVariables.XDG_CLOUD_HOME}/.data/dropbox";
      apply = toString;
    };

    linkHomeDirs = mkEnableOption ''
      Whether to automatically link directories inside Dropbox's home
      directories
    '';

    homeSubdir = mkOption {
      description = ''
        Files will be linked from this Dropbox subdirectory to
        $HOME
      '';
      type = with types; str;
      default = "home";
      example = "Dotfiles/home";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.dropbox-cli ];

    systemd.user.services.dropbox = let
      dropboxCmd = "${pkgs.dropbox-cli}/bin/dropbox";
    in {
      Unit = { Description = "dropbox"; };

      Install = { WantedBy = [ "default.target" ]; };

      Service = {
        Environment = [ "HOME=${cfg.truePath}" "DISPLAY=" ];

        Type = "forking";
        PIDFile = "${cfg.truePath}/.dropbox/dropbox.pid";

        Restart = "on-failure";
        PrivateTmp = true;
        ProtectSystem = "full";
        Nice = 10;

        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${dropboxCmd} stop";
        ExecStart = toString (pkgs.writeShellScript "dropbox-start" ''
          # ensure we have the dirs we need
          $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir $VERBOSE_ARG -p \
            ${cfg.truePath}/{.dropbox,.dropbox-dist,Dropbox}

          # running as a user needs the same .dropbox as the one in `truePath`
          if [[ ! -d ${config.home.homeDirectory}/.dropbox ]]
          then
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/ln $VERBOSE_ARG -s \
              ${cfg.truePath}/.dropbox ${config.home.homeDirectory}/.dropbox
          fi

          if [[ ! -d ${escapeShellArg cfg.linkPath} ]]
          then
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/ln $VERBOSE_ARG -s \
              ${cfg.truePath}/Dropbox ${escapeShellArg cfg.linkPath}
          fi
          # get the dropbox bins if needed
          if [[ ! -f $HOME/.dropbox-dist/VERSION ]]; then
            ${pkgs.coreutils}/bin/yes | ${dropboxCmd} update
          fi
          ${dropboxCmd} start
        '');
      };
    };

    home.activation = mkIf cfg.linkHomeDirs {
      linkDropboxHomeDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        for f in `ls "${cfg.linkPath}/${cfg.homeSubdir}"`
        do
          if [ -e "${config.home.homeDirectory}/$f" ]
          then
            current_src=`realpath "${config.home.homeDirectory}/$f" 2>/dev/null`
            true_src=`realpath "${cfg.linkPath}/${cfg.homeSubdir}/$f" 2>/dev/null`
            if [ "$current_src" != "$true_src" ]
            then
              echo "Could not link '${config.home.homeDirectory}/$f': file exists!"
            fi
          else
            echo "Linking '$f' from '${cfg.linkPath}/${cfg.homeSubdir}'"
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/ln -s $VERBOSE_ARG \
              ${cfg.linkPath}/${cfg.homeSubdir}/$f \
              ${config.home.homeDirectory}/$f
          fi
        done
      '';
    };
  };
}
