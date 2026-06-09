{ config, pkgs, ... }:
# TODO maybe unify it with variables

let
  defaultDirs = rec {
    # xdg
    XDG_TEMPLATES_DIR = "${XDG_RESOURCES_DIR}/tpt";
    XDG_DOCUMENTS_DIR = "${XDG_HOME_DIR}/doc";
    XDG_PICTURES_DIR = "${XDG_HOME_DIR}/pic";
    XDG_VIDEOS_DIR = "${XDG_HOME_DIR}/vid";
    XDG_MUSIC_DIR = "${XDG_HOME_DIR}/mus";
    XDG_DESKTOP_DIR = "${XDG_TMP_DIR}/dkt";
    XDG_DOWNLOAD_DIR = "${XDG_TMP_DIR}/dld";
    XDG_PUBLICSHARE_DIR = "${XDG_TMP_DIR}/shr";
    XDG_CONFIG_HOME  =  "${config.xdg.configHome}";
    XDG_DATA_HOME  =  "${config.xdg.dataHome}";
    XDG_STATE_HOME  =  "${config.xdg.stateHome}";
    # custom
    XDG_HOME_DIR = "${config.home.homeDirectory}/hom";
    XDG_PROJECTS_DIR = "${config.home.homeDirectory}/prj";
    XDG_BIN_HOME  = "${config.home.homeDirectory}/.local/bin";
    XDG_RESOURCES_DIR  = "${config.home.homeDirectory}/res";
    XDG_CAPTURE_DIR = "${config.home.homeDirectory}/cap";
    XDG_TMP_DIR  = "${config.home.homeDirectory}/tmp";
    XDG_WALLPAPER_DIR  = "${XDG_RESOURCES_DIR}/wal";
    XDG_SCREENSHOT_DIR  = "${XDG_CAPTURE_DIR}/scr";
    XDG_MAIL_DIR  = "${XDG_DATA_HOME}/mail";
    XDG_CLOUD_HOME = "${config.home.homeDirectory}/cld";  # ??
    XDG_DOCUMENTS_DATA ="${XDG_DOCUMENTS_DIR}/h/dat";  # ??
  };
in
{
  home.sessionVariables = defaultDirs;

  xdg.userDirs = rec {
    enable = true;
    #createDirectories = true;  # TODO replace with script that considers cloud symlinks
    extraConfig = defaultDirs;
  };
}
