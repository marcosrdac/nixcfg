{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    lf

    dmenu
    brightnessctl  # adjust lights
  ];

  #home.language.base = "us";

  home.keyboard = {
    layout = "us";
    variant = "intl";
    options = [ "caps:swapescape" ];
  };

  #home.shellAliases = { };  # not yet valid

  xsession = {
    enable = true;
    scriptPath = ".xsession-hm";

    windowManager.bspwm = {
      enable = true;
      extraConfig = builtins.readFile ./config/bspwm/bspwmrc;
    };
  };
  services.sxhkd = {
    enable = true;
    extraConfig = builtins.readFile ./config/sxhkd/sxhkdrc;
  };

  services.polybar = {
    enable = true;
    script = builtins.readFile ./config/polybar/config;
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
  
  home.sessionVariables = {
    TERMINAL = "alacritty";
    BROWSER = "qutebrowser";


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
