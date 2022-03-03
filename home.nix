{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotDir = "${config.xdg.configHome}/nixpkgs";
  dotConfig = "${dotDir}/config";
  dotBin = "${dotDir}/bin";
in
{
  imports = [
    ./modules/git
    ./modules/polybar
  ];
  
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nox
    starship
    htop
    scrot
    xclip xsel

    ueberzug

    pywal

    ripgrep

    unstable.spotify
    tdesktop
    write_stylus

    inkscape gimp

    fzy ydotool xdotool

    libnotify  #=: notify-send
    brightnessctl  # light control
    pamixer  # sound control
  ];


  services.dunst = {
    enable = true;
  };

  services.picom = {
    enable = true;
    package = pkgs.unstable.picom;
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
      blur-method = "dual_kawase"
      #blur-strength = 3
      #blur-method = "gaussian"
      #blur-size = 9
      #blur-deviation = 10
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

  programs.alacritty.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    extraConfig = builtins.concatStringsSep "\n" [
    #  (lib.strings.fileContents ./base.vim)
    #  (lib.strings.fileContents ./plugins.vim)
    #  (lib.strings.fileContents ./lsp.vim)
    #  # this allows you to add lua config files
    #  ''
    #    lua << EOF
    #    ${lib.strings.fileContents ./config.lua}
    #    ${lib.strings.fileContents ./lsp.lua}
    #    EOF
    #  ''
    ];
    extraPackages = with pkgs; [
      # used to compile tree-sitter grammar
      #tree-sitter

      # installs different langauge servers for neovim-lsp
      # have a look on the link below to figure out the ones for your languages
      # https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
      #nodePackages.typescript nodePackages.typescript-language-server
      #gopls
      #nodePackages.pyright
      #rust-analyzer
    ];
    plugins = with pkgs.vimPlugins; [
      # you can use plugins from the pkgs
      vim-which-key
      #vim-quick-scope

      ## or you can use our function to directly fetch plugins from git
      #(plugin "neovim/nvim-lspconfig")
      #(plugin "hrsh7th/nvim-compe") # completion
      #(plugin "Raimondi/delimitMate") # auto bracket

      ## this installs the plugin from 'lua' branch
      #(pluginGit "lua" "lukas-reineke/indent-blankline.nvim")

      ## syntax highlighting
      #(plugin "nvim-treesitter/nvim-treesitter")
      #(plugin "p00f/nvim-ts-rainbow") # bracket highlighting
    ];
  };
  

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

    #"lf/lfrc".text = builtins.concatStringsSep "\n" [
    #  (builtins.readFile ./config/lf/lfrc)
    #  "# Image previews need ${pkgs.ueberzug}"
    #];
    "lf".source = mkOutOfStoreSymlink "${dotConfig}/lf";
    #"lf/icons" = {
    #  source = ./config/lf/icons;
    #  executable = true;
    #};
    #"lf/lfimg/previer" = {
    #  source = ./config/lf/lfimg/preview;
    #  executable = true;
    #};
    #"lf/lfimg/cleaner" = {
    #  source = ./config/lf/lfimg/cleaner;
    #  executable = true;
    #};


    "dunst/dunstrc.base" = {
      source = ./config/dunst/dunstrc.base;
    };
    "wal" = {
      source = ./config/wal;
      recursive = true;
    };
  };
  
  programs.zsh = {
    enable = true;
    shellAliases = {
      # home-manager
      hm = "home-manager";
      hms = "home-manager switch --flake ${config.xdg.configHome}/nixpkgs#`hostname`";
      ehm = "$EDITOR ${config.xdg.configHome}/nixpkgs/home.nix";

      # making it easy
      n = "lf";
      ll = "ls -l";
      lf = "${dotConfig}/lf/bin/lf-ueberzug";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

}
