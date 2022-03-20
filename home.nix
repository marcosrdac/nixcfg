{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotDir = "${config.xdg.configHome}/nixpkgs";
  dotConfig = "${dotDir}/config";
  dotBin = "${dotDir}/bin";
  linkChildren = (
    dir: linkdir: builtins.listToAttrs (
    map (filename: {
      name = "${linkdir}/${filename}";
      value = with config.lib.file; {
        source = mkOutOfStoreSymlink ("${dir}/${filename}");
      };
    }) (builtins.attrNames (builtins.readDir dir)))
  );
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
  imports = [
    ./modules/shell
    ./modules/graphics
    ./modules/git
    ./modules/polybar
    ./modules/nvim
    ./modules/bspwm
  ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    st
    nox
    htop
    scrot
    xclip xsel

    ripgrep
    #xpdf  #=: pdftotext, pdfimages - tagged insecure (?)

    #polybar

    lf xfce.thunar

    # browsers
    qutebrowser firefox google-chrome
    # pdf readers
    zathura evince

    pacman
    ueberzug

    pywal
    flavours

    unstable.spotify
    tdesktop
    write_stylus

    inkscape gimp

    fzy ydotool xdotool

    libnotify      #=: notify-send
    brightnessctl  # light control
    pamixer        # sound control

    pandoc
    texlive.combined.scheme-full

    julia_16-bin

    tmatrix
  ];


  services.dunst = {
    enable = true;
  };

  services.picom = {
    enable = true;
    #package = pkgs.unstable.picom;
    package = pkgs.picom;
    activeOpacity = "1.0";
    menuOpacity = "1.0";
    inactiveOpacity = "1.0";
    inactiveDim = "0.2";
    blur = true;
    backend = "glx";
    refreshRate = 0;
    experimentalBackends = true;
    fade = false;
    fadeDelta = 10;
    fadeSteps = [ "0.028" "0.03" ];
    shadow = false;
    shadowOpacity = "0.75";
    shadowOffsets = [ (-15) (-15) ];  # H&V
    opacityRule = [
      "90:class_g = 'St' && focused"
      "90:class_g = 'Alacritty' && focused"
      "90:class_g = 'dmenu' && focused"
      "90:class_g = 'Polybar'"
      "90:class_g = 'Spotify' && focused"
      #"90:class_g = 'Zathura' && focused"
      "90:class_g = 'tchoice' && focused"
      "90:class_g = 'dropdown_terminal' && focused"
      "90:class_g = 'dropdown_calculator' && focused"
      "90:class_g = 'dropdown_mail' && focused"
      "90:class_g = 'dropdown_music_player' && focused"
      #"90:class_g = 'qutebrowser' && focused"
      "80:class_g = 'St' && !focused"
      "80:class_g = 'Alacritty' && !focused"
      "80:class_g = 'dmenu' && !focused"
      "80:class_g = 'Spotify' && !focused"
      #"80:class_g = 'Zathura' && !focused"
      "80:class_g = 'tchoice' && !focused"
      "80:class_g = 'dropdown_terminal' && !focused"
      "80:class_g = 'dropdown_calculator' && !focused"
      "80:class_g = 'dropdown_mail' && !focused"
      "80:class_g = 'dropdown_music_player' && !focused"
      #"80:class_g = 'qutebrowser' && !focused"
    ];
    blurExclude = [ ];
    fadeExclude = [ ];
    shadowExclude = [ ];
    noDockShadow = true;
    extraOptions = ''
      #blur-method = "dual_kawase"
      #blur-strength = 3
      blur-method = "gaussian"
      blur-size = 9
      blur-deviation = 10

      #corner-radius = 1
    '';
  };

  home.sessionPath = [
    binHome
  ] ++ (builtins.attrNames (linkChildren ./bin binHome));

  home.sessionVariables = let
    myscript = pkgs.writeShellScriptBin "myscpt" ''
      #!/usr/bin/env sh
      echo hello world
    '';
    in (
      defaultDirs // {
      MYSCRIPT = "${myscript}/bin/myscpt";

      OPENER = "xdg-open";
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "alacritty";
      FILEBROWSER = "${dotConfig}/lf/bin/lf-ueberzug";
      BROWSER = "qutebrowser";
      ALTBROWSER = "$firefox";
      ALTALTBROWSER = "google-chrome-stable";
      READER = "zathura";
      PAGER = "less";
      VIDEOPLAYER = "mpv";
      TRUEBROWSER = "qutebrowser";
      XIMAGEVIEWER = "sxiv";
      MENU = "menu";
      MENURUN = "menurun";
    });

  #home.language.base = "us";

  home.keyboard = {
    #layout = "br";
    layout = "us";
    variant = "intl";
    options = [ "caps:swapescape" ];
  };

  home.shellAliases = {
    # home-manager
    hm = "home-manager";
    hms = "home-manager switch --flake ${config.xdg.configHome}/nixpkgs#`hostname`";
    ehm = "$EDITOR ${config.xdg.configHome}/nixpkgs/home.nix";

    # making it easy
    n = "$FILEBROWSER";
    ll = "ls -l";
    lf = "$FILEBROWSER";
  };  # not yet valid

  services.network-manager-applet.enable = true;

  programs.alacritty.enable = true;

  xdg.userDirs = rec {
    enable = true;
    createDirectories = true;
    extraConfig = defaultDirs;
  };

  home.file = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
      # bspwm
      "${binHome}/bspwm_window_move".source = mkLink "${dotConfig}/bspwm/bin/bspwm_window_move";
      "${binHome}/bspwm_toggle_state".source = mkLink "${dotConfig}/bspwm/bin/bspwm_toggle_state";
      # default example
      #"${binHome}/bspwm_toggle_state" = {
      #  source = ./config/bspwm/bin/bspwm_toggle_state;
      #  executable = true;
      #};
    }
    // linkChildren ./bin binHome;

  xdg.configFile = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
    "sxhkd".source = mkLink "${dotConfig}/sxhkd";
    "flavours".source = mkLink "${dotConfig}/flavours";
    "lf".source = mkLink "${dotConfig}/lf";
    "qutebrowser" = {
      source = ./config/qutebrowser;
      recursive = true;
    };
    "GIMP" = {
      source = ./config/GIMP;
      recursive = true;
    };
    "dunst/dunstrc.base" = {
      source = ./config/dunst/dunstrc.base;
    };
    "wal" = {
      source = ./config/wal;
      recursive = true;
    };

  };

}
