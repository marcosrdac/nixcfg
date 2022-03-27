{ config, pkgs, ... }:

let
  defaultDirs = rec {
    # xdg
    XDG_DOCUMENTS_DIR = "$HOME/dox";
    XDG_MUSIC_DIR = "$HOME/mus";
    XDG_PICTURES_DIR = "$HOME/pix";
    XDG_PUBLICSHARE_DIR = "$HOME/pub";
    XDG_TEMPLATES_DIR = "${XDG_RESOURCES_DIR}/tpt";
    XDG_VIDEOS_DIR = "$HOME/vid";
    XDG_DOWNLOAD_DIR = "${XDG_TMP_DIR}/dld";
    XDG_DESKTOP_DIR = "${XDG_TMP_DIR}/dkt";
    XDG_CONFIG_HOME  =  "${config.xdg.configHome}";
    XDG_DATA_HOME  =  "${config.xdg.dataHome}";
    # custom
    XDG_PROJECTS_DIR = "$HOME/pro";
    XDG_BIN_HOME  = "$HOME/.local/bin";
    XDG_RESOURCES_DIR  = "$HOME/res";
    XDG_TMP_DIR  = "$HOME/tmp";
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
