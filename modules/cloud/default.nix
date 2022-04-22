{ config, pkgs, ... }:

let
  defaultDirs = rec {
    XDG_CLOUD_HOME = "${config.home.homeDirectory}/.cld";
    XDG_DROPBOX_DIR = "${XDG_CLOUD_HOME}/dropbox";
    XDG_DROPBOX_STORAGE = "${XDG_CLOUD_HOME}/.data/dropbox";  # varies from PC to PC
    XDG_MEGA_DIR = "${XDG_CLOUD_HOME}/mega";
  };
in {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = defaultDirs;
  };

  services.dropbox = {
    enable = true;
    path = defaultDirs.XDG_DROPBOX_DIR;
  };

#  # START DROPBOX
#
#  home.packages = [ pkgs.dropbox-cli ];
#
#  systemd.user.services.dropbox = {
#    Unit = { Description = "dropbox"; };
#
#    Install = { WantedBy = [ "default.target" ]; };
#
#    Service = let
#        dropboxCmd = "${pkgs.dropbox-cli}";
#      in {
#        Environment = [ "HOME=${defaultDirs.XDG_DROPBOX_STORAGE}" "DISPLAY=" ];
#
#        Type = "forking";
#        PIDFile = "${defaultDirs.XDG_DROPBOX_STORAGE}/.dropbox/dropbox.pid";
#
#        Restart = "on-failure";
#        PrivateTmp = true;
#        ProtectSystem = "full";
#        Nice = 10;
#
#        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
#        ExecStop = "${dropboxCmd} stop";
#        ExecStart = toString (pkgs.writeShellScript "dropbox-start" ''
#          # ensure we have the dirs we need
#          $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir $VERBOSE_ARG -p \
#            ${defaultDirs.XDG_DROPBOX_STORAGE}/{.dropbox,.dropbox-dist,Dropbox}
#          # get the dropbox bins if needed
#          if [[ ! -f $HOME/.dropbox-dist/VERSION ]]; then
#            ${pkgs.coreutils}/bin/yes | ${dropboxCmd} update
#          fi
#          ${dropboxCmd} start
#        '');
#      };
#  };
#
#  # linking
#  # if [[ ! -d ${config.home.homeDirectory}/.dropbox ]]; then
#  #   $DRY_RUN_CMD ${pkgs.coreutils}/bin/ln $VERBOSE_ARG -s \
#  #     ${defaultDirs.XDG_DROPBOX_STORAGE}/.dropbox ${config.home.homeDirectory}/.dropbox
#  # fi
#  # if [[ ! -d ${escapeShellArg cfg.path} ]]; then
#  #   $DRY_RUN_CMD ${pkgs.coreutils}/bin/ln $VERBOSE_ARG -s \
#  #     ${defaultDirs.XDG_DROPBOX_STORAGE}/Dropbox ${escapeShellArg cfg.path}
#  # fi
#
#  # END DROPBOX


  home.file = let
    mkLink = config.lib.file.mkOutOfStoreSymlink;
    dropbox-home = "${defaultDirs.XDG_DROPBOX_DIR}/home";
  in {
    dox.source = mkLink "${dropbox-home}/dox";
    pix.source = mkLink "${dropbox-home}/pix";
    pro.source = mkLink "${dropbox-home}/pro";
    res.source = mkLink "${dropbox-home}/res";
  };
}
