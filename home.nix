{ config, pkgs, nix-colors, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotDir = "${config.xdg.configHome}/nixpkgs";
  dotConfig = "${dotDir}/config";
  dotBin = "${dotDir}/bin";
  linkChildren = dir: linkdir: builtins.listToAttrs (
    map (filename: {
      name = "${linkdir}/${filename}";
      value = with config.lib.file; {
        source = mkOutOfStoreSymlink "${dir}/${filename}";
        #source = mkOutOfStoreSymlink ./. + dir + filename ;
      };
    }) (builtins.attrNames (builtins.readDir dir)));
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
    nix-colors.homeManagerModule
    ./modules/shell
    ./modules/graphics
    ./modules/git
    ./modules/polybar
  ];

  #colorscheme = nix-colors.colorSchemes.dracula;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim

    st
    nox
    htop
    scrot
    xclip xsel

    sxiv

    ripgrep
    #xpdf  #=: pdftotext, pdfimages - tagged insecure (?)

    #polybar

    lf xfce.thunar

    # browsers
    qutebrowser firefox google-chrome
    # pdf readers
    zathura evince

    ueberzug

    feh flavours pywal

    unstable.spotify
    tdesktop
    unstable.write_stylus

    inkscape gimp
    imagemagick

    fzy ydotool xdotool

    discord teams zoom-us

    libnotify      #=: notify-send
    brightnessctl  # light control
    pamixer        # sound control

    pandoc
    texlive.combined.scheme-full

    julia_16-bin

    tmatrix
  ];


  services.dunst.enable = true;

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
      ALTBROWSER = "firefox";
      ALTALTBROWSER = "google-chrome-stable";
      READER = "zathura";
      PAGER = "less";
      VIDEOPLAYER = "mpv";
      TRUEBROWSER = "qutebrowser";
      XIMAGEVIEWER = "sxiv";
      MENU = "menu";
      MENURUN = "menurun";
    });

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

  #programs.alacritty = {
  #  enable = true;
  #  settings = {
  #    colors = {
  #      primary = {
  #        #background = "0x${config.colorscheme.colors.base00-hex}";
  #        #foreground = "0x${config.colorscheme.colors.base05-hex}";
  #      };
  #      ## Colors the cursor will use if `custom_cursor_colors` is true
  #      #cursor:
  #      #  text: '0x{{base00-hex}}'
  #      #  cursor: '0x{{base05-hex}}'
  #      ## Normal colors
  #      #normal:
  #      #  black:   '0x{{base00-hex}}'
  #      #  red:     '0x{{base08-hex}}'
  #      #  green:   '0x{{base0B-hex}}'
  #      #  yellow:  '0x{{base0A-hex}}'
  #      #  blue:    '0x{{base0D-hex}}'
  #      #  magenta: '0x{{base0E-hex}}'
  #      #  cyan:    '0x{{base0C-hex}}'
  #      #  white:   '0x{{base05-hex}}'
  #      ## Bright colors
  #      #bright:
  #      #  black:   '0x{{base03-hex}}'
  #      #  red:     '0x{{base09-hex}}'
  #      #  green:   '0x{{base01-hex}}'
  #      #  yellow:  '0x{{base02-hex}}'
  #      #  blue:    '0x{{base04-hex}}'
  #      #  magenta: '0x{{base06-hex}}'
  #      #  cyan:    '0x{{base0F-hex}}'
  #      #  white:   '0x{{base07-hex}}'
  #    };
  #    draw_bold_text_with_bright_colors = false;
  #  };
  #};

  xdg.userDirs = rec {
    enable = true;
    createDirectories = true;
    extraConfig = defaultDirs;
  };

  home.file = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
      "${config.xdg.dataHome}/flavours/base16/templates" = {
        source = ./config/flavours/templates;
        recursive = true;
      };
    } // linkChildren ./bin binHome;

  xdg.configFile = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
    "sxhkd".source = mkLink "${dotConfig}/sxhkd";
    "flavours".source = mkLink "${dotConfig}/flavours";
    "zathura/zathurarc".source = mkLink "${dotConfig}/zathura/zathurarc";
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
    #// (linkChildren ./config/alacritty "${config.xdg.configHome}/alacritty");

}
