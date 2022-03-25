{ config, pkgs, inputs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotConfig = ./config;
  dotBin = ./bin;
#  linkChildren = dir: linkdir: builtins.listToAttrs (
#    map (filename: {
#      name = "${linkdir}/${filename}";
#      value = with config.lib.file; {
#        #source = mkOutOfStoreSymlink "${builtins.toString dir}/${filename}";
#        #source = mkOutOfStoreSymlink (dir + "/${filename}");
#        #source = mkOutOfStoreSymlink "${dir}/${filename}";
#        #source = mkOutOfStoreSymlink ./. + dir + filename ;
#        #source = mkOutOfStoreSymlink dir + "/${filename}" ;
#        source = mkOutOfStoreSymlink dir/${filename};
#      };
#    }) (builtins.attrNames (builtins.readDir dir)));
  linkChildren = dir: linkdir: builtins.listToAttrs (
    map (filename: {
      name = "${builtins.toString linkdir}/${filename}";
      value = { source = config.lib.file.mkOutOfStoreSymlink "${builtins.toString dir}/${filename}"; };
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
  defaultPrograms = rec {
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
  };
in
{
  imports = [
    ./theme.nix
    ./modules/terminal
    ./modules/shell
    ./modules/git
    ./modules/graphics
    ./modules/programs
    ./modules/fonts
  ];

  #colorscheme = inputs.nix-colors.colorSchemes.solarized-dark;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    #(callPackage (import ./packages/nvim) {})
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
    evince

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


  home.sessionPath = [
    binHome
  ] ++ (builtins.attrNames (linkChildren ./bin binHome));

  home.sessionVariables = let
    myscript = pkgs.writeShellScriptBin "myscpt" ''
      #!/usr/bin/env sh
      echo hello world
    '';
    mkNixConfigFunction = pkgs.writeShellScriptBin "mkNixConfigFunction" ''
      #!/usr/bin/env sh
      [ -e default.nix ] || (echo "{ config, pkgs, ... }:\n\n{\n\n}" > default.nix)
    '';
    in (
      defaultDirs // defaultPrograms // {
      MYSCRIPT = "${myscript}/bin/myscpt";
      MKNIXCONFIGFUNCTION = "${mkNixConfigFunction}/bin/mkNixConfigFunction";
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

  xdg.userDirs = rec {
    enable = true;
    createDirectories = true;
    extraConfig = defaultDirs;
  };

  #home.file = let
  #  mkLink = config.lib.file.mkOutOfStoreSymlink;
  #in {
  #    "${config.xdg.dataHome}/flavours/base16/templates" = {
  #      source = ./config/flavours/templates;
  #      recursive = true;
  #    };
  #    "test".source = mkLink ./bin/show_timer;
  #    ".local/bin/show".source = mkLink ./bin/show_timer;
  #  #} // linkChildren ./bin binHome;
  #} // linkChildren ./bin ".local/bin";

  #xdg.configFile = let
  #    mkLink = config.lib.file.mkOutOfStoreSymlink;
  #  in {
  #  "flavours".source = mkLink "${dotConfig}/flavours";
  #  "zathura/zathurarc".source = mkLink "${dotConfig}/zathura/zathurarc";
  #  "lf".source = mkLink "${dotConfig}/lf";
  #  "qutebrowser" = {
  #    source = ./config/qutebrowser;
  #    recursive = true;
  #  };
  #  "GIMP" = {
  #    source = ./config/GIMP;
  #    recursive = true;
  #  };
  #  "wal" = {
  #    source = ./config/wal;
  #    recursive = true;
  #  };

  #};

}
