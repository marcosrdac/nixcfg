{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
in
{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop

    ripgrep

    #bash
    fzy
    ydotool
    xdotool

    brightnessctl  # light control
  ];

  home.sessionPath = [ binHome ];

  home.sessionVariables = {
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
    BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";
    FILEMANAGER = "${pkgs.lf}/bin/lf";
  };

  home.file = rec {
    # general
    "${binHome}/tchoice" = {
      source = ./bin/tchoice;
      executable = true;
    };
    "${binHome}/menu" = {
      source = ./bin/tchoice;
      executable = true;
    };

    "${binHome}/tlauncher" = {
      source = ./bin/tlauncher;
      executable = true;
    };
    "${binHome}/menu-run" = {
      source = ./bin/tlauncher;
      executable = true;
    };

    "${binHome}/test-script" = {
      source = ./bin/test-script;
      executable = true;
    };

    # bspwm
    "${binHome}/bspwm_window_move" = {
      source = ./config/bspwm/bin/bspwm_window_move;
      executable = true;
    };
    "${binHome}/bspwm_toggle_state" = {
      source = ./config/bspwm/bin/bspwm_toggle_state;
      executable = true;
    };
    "${binHome}/bspwm_external_rules" = {
      source = ./config/bspwm/bin/bspwm_external_rules;
      executable = true;
    };
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

  #services.polybar = {
  #  enable = true;
  #  config = ./config/polybar/config;
  #  script = ''
  #    polybar 1
  #  '';
  #};

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
  
  # home.file.".vimrc".text = " ...";
  # xdg.configFile."sxhkd/sxhkdrc".source = ./config/sxhkd/sxhkdrc;
  
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
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  programs.git = {
    enable = true;
    userName = "marcosrdac";
    userEmail = "marcosrdac@gmail.com";
    aliases = {
      s = "status";
    };
  };

}
