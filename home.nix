{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotDir = "${config.xdg.configHome}/nixpkgs";
  dotConfig = "${dotDir}/config";
  dotBin = "${dotDir}/bin";
in
{
  imports = [
    ./modules/shell
    ./modules/git
    ./modules/polybar
    ./modules/nvim
  ];
  
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    st
    nox
    htop
    scrot
    xclip xsel

    #polybar

    zathura
    evince
    ueberzug

    pywal

    ripgrep

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

  home.sessionPath = [ binHome ];

  home.sessionVariables = {
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
    BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
    ALTBROWSER = "${pkgs.firefox}/bin/firefox";
    ALTALTBROWSER = "${pkgs.google-chrome}/bin/google-chrome-stable";
    FILEMANAGER = "${pkgs.lf}/bin/lf";
    PDFREADER = "${pkgs.zathura}/bin/zathura";
  };

  #home.language.base = "us";

  home.keyboard = {
    layout = "us";
    variant = "intl";
    options = [ "caps:swapescape" ];
  };
  
  #home.shellAliases = { };  # not yet valid

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";

    windowManager.bspwm = {
      enable = true;
      extraConfig = builtins.readFile ./config/bspwm/bspwmrc;
      startupPrograms = [
        "${pkgs.sxhkd}/bin/sxhkd -c ${config.xdg.configHome}/nixpkgs/config/sxhkd/sxhkdrc"
      ];
    };
  };

  programs.zsh.shellAliases = {
      # home-manager
      hm = "home-manager";
      hms = "home-manager switch --flake ${config.xdg.configHome}/nixpkgs#`hostname`";
      ehm = "$EDITOR ${config.xdg.configHome}/nixpkgs/home.nix";

      # making it easy
      n = "lf";
      ll = "ls -l";
      lf = "${dotConfig}/lf/bin/lf-ueberzug";
    };

  programs.alacritty.enable = true;

  xdg.enable = true;

  xdg.userDirs = {
    documents = "$HOME/tmp/dox";
    pictures = "$HOME/tmp/pix";
    music = "$HOME/mus";
    videos = "$HOME/vid";
    templates = "$HOME/tpt";
    publicShare = "$HOME/pub";
    desktop = "$HOME/tmp";
    download = "$HOME/tmp/dld";
    extraConfig = { };
  };

  home.file = with config.lib.file; {
    # terminal menu / launcher
    "${binHome}/tchoice".source = mkOutOfStoreSymlink "${dotBin}/tchoice";
    "${binHome}/menu".source = mkOutOfStoreSymlink "${dotBin}/tchoice";
    "${binHome}/tlauncher".source = mkOutOfStoreSymlink "${dotBin}/tlauncher";
    "${binHome}/menu-run".source = mkOutOfStoreSymlink "${dotBin}/tlauncher";
    "${binHome}/test-script".source = mkOutOfStoreSymlink "${dotBin}/test-script";

    "${binHome}/xorg-screenshot".source = mkOutOfStoreSymlink "${dotBin}/xorg-screenshot";
    "${binHome}/wayland-screenshot".source = mkOutOfStoreSymlink "${dotBin}/wayland-screenshot";

    # bspwm
    "${binHome}/bspwm_window_move".source = mkOutOfStoreSymlink "${dotConfig}/bspwm/bin/bspwm_window_move";
    "${binHome}/bspwm_toggle_state".source = mkOutOfStoreSymlink "${dotConfig}/bspwm/bin/bspwm_toggle_state";
    # default example
    #"${binHome}/bspwm_toggle_state" = {
    #  source = ./config/bspwm/bin/bspwm_toggle_state;
    #  executable = true;
    #};
  };

  xdg.configFile = with config.lib.file; {
    "qutebrowser" = {
      source = ./config/qutebrowser;
      recursive = true;
    };
    "GIMP" = {
      source = ./config/GIMP;
      recursive = true;
    };
    #"polybar/config".source = mkOutOfStoreSymlink "${dotConfig}/polybar/config";

    "lf".source = mkOutOfStoreSymlink "${dotConfig}/lf";

    "dunst/dunstrc.base" = {
      source = ./config/dunst/dunstrc.base;
    };
    "wal" = {
      source = ./config/wal;
      recursive = true;
    };
  };


}
