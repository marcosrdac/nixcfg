{ config, pkgs, ... }:
# TODO maybe unify it with variables

let
  defaultDirs = rec {
    # xdg
    XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/dox";
    XDG_MUSIC_DIR = "${config.home.homeDirectory}/mus";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/pix";
    XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/pub";
    XDG_TEMPLATES_DIR = "${XDG_RESOURCES_DIR}/tpt";
    XDG_VIDEOS_DIR = "${config.home.homeDirectory}/vid";
    XDG_DOWNLOAD_DIR = "${XDG_TMP_DIR}/dld";
    XDG_DESKTOP_DIR = "${XDG_TMP_DIR}/dkt";
    XDG_CONFIG_HOME  =  "${config.xdg.configHome}";
    XDG_DATA_HOME  =  "${config.xdg.dataHome}";
    # custom
    XDG_PROJECTS_DIR = "${config.home.homeDirectory}/pro";
    XDG_BIN_HOME  = "${config.home.homeDirectory}/.local/bin";
    XDG_RESOURCES_DIR  = "${config.home.homeDirectory}/res";
    XDG_TMP_DIR  = "${config.home.homeDirectory}/tmp";
    XDG_WALLPAPER_DIR  = "${XDG_RESOURCES_DIR}/wal";
    XDG_SCREENSHOT_DIR  = "${XDG_PICTURES_DIR}/scr";
    XDG_MAIL_DIR  = "${XDG_DATA_HOME}/mail";
    XDG_DOCUMENTS_DATA ="${XDG_DOCUMENTS_DIR}/h/dat";
  };
in 
{
  home.sessionVariables = defaultDirs;

  xdg.userDirs = rec {
    enable = true;
    createDirectories = true;
    extraConfig = defaultDirs;
  };
}
