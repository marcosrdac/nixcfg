{ config, pkgs, ... }:
# TODO maybe unify it with variables

let
  defaultDirs = rec {
    # xdg
    TEMPLATES = "${RESOURCES}/tpt";
    DOCUMENTS = "${FAKE_HOME}/doc";
    PICTURES = "${FAKE_HOME}/pic";
    VIDEOS = "${FAKE_HOME}/vid";
    MUSIC = "${FAKE_HOME}/mus";
    DESKTOP = "${TMP}/dkt";
    DOWNLOAD = "${TMP}/dld";
    PUBLICSHARE = "${TMP}/shr";
    CONFIG_HOME  =  "${config.xdg.configHome}";
    DATA_HOME  =  "${config.xdg.dataHome}";
    STATE_HOME  =  "${config.xdg.stateHome}";
    # custom
    FAKE_HOME = "${config.home.homeDirectory}/hom";
    PROJECTS = "${config.home.homeDirectory}/prj";
    BIN_HOME  = "${config.home.homeDirectory}/.local/bin";
    RESOURCES  = "${config.home.homeDirectory}/res";
    CAPTURE = "${config.home.homeDirectory}/cap";
    TMP  = "${config.home.homeDirectory}/tmp";
    WALLPAPER  = "${RESOURCES}/wal";
    SCREENSHOT  = "${CAPTURE}/scr";
    MAIL  = "${DATA_HOME}/mail";
    CLOUD_HOME = "${config.home.homeDirectory}/cld";  # ??
    DOCUMENTS_DATA ="${DOCUMENTS}/h/dat";  # ??
  };
in
{
  home.sessionVariables = defaultDirs;

  xdg.userDirs = rec {
    enable = true;
    setSessionVariables = true;
    createDirectories = false;  # TODO replace with script that considers cloud symlinks
    extraConfig = defaultDirs;
    # user dirs
    desktop = defaultDirs.DESKTOP;
    documents = defaultDirs.DOCUMENTS;
    pictures = defaultDirs.PICTURES;
    videos = defaultDirs.VIDEOS;
    music = defaultDirs.MUSIC;
    templates = defaultDirs.TEMPLATES;
    download = defaultDirs.DOWNLOAD;
    publicShare = defaultDirs.PUBLICSHARE;
  };
}
