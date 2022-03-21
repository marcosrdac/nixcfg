{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotDir = "${config.xdg.configHome}/nixpkgs";
  dotConfig = "${dotDir}/config";
  dotBin = "${dotDir}/bin";
  nvimConfig = "${config.xdg.configHome}/nvim";
in
{
  xdg.configFile = let
      mkLink = pkgs.lib.file.mkOutOfStoreSymlink;
    in {
    #"nvim/autoload" = {
    #  source = ./autoload;
    #  recursive = true;
    #};
    "nvim/colors" = {
      source = ./colors;
      recursive = true;
    };
    "nvim/ftplugin" = {
      source = ./ftplugin;
      recursive = true;
    };
    "nvim/spell" = {
      source = ./spell;
      recursive = true;
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.concatStringsSep "\n" [
      # TODO add if extraconfig then load it (by computer)
      (pkgs.lib.strings.fileContents ./base.vim)
      (pkgs.lib.strings.fileContents ./mappings.vim)
      (pkgs.lib.strings.fileContents ./scripts.vim)
      (pkgs.lib.strings.fileContents ./variables.vim)
      (pkgs.lib.strings.fileContents ./plugins.vim)
      (pkgs.lib.strings.fileContents ./abbreviations.vim)
      (pkgs.lib.strings.fileContents ./automation.vim)
      ''
        " other configs
      ''
    ];
    extraPackages = with pkgs; [
      tree-sitter  # compile tree-sitter grammar
      # installs different langauge servers for neovim-lsp
      # have a look on the link below to figure out the ones for your languages
      # https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
      #nodePackages.typescript nodePackages.typescript-language-server
      #gopls
      #nodePackages.pyright
      #rust-analyzer
    ];
  
    #package = pkgs.neovim.override {
    #  configure = {
    #    plugins = with pkgs.vimPlugins; [
    #      ale
    #      goyo
    #    ];
    #  };
    #};
  
    plugins = with pkgs.vimPlugins; let
      unstable = pkgs.unstable.vimPlugins; in[
      # navigation
      quick-scope
      vim-tmux-navigator
  
      # crypting
      vim-gnupg
  
      # vimwiki
      vimwiki
      # calendar-vim integration
      calendar-vim
  
      # viewing colors
      nvim-colorizer-lua
      vim-hexokinase
      #nvim-treesitter
  
      # computer language syntax checkers
      ale  # async syntax checking
  
      # natural language checkers
      LanguageTool-nvim
  
      # focused writing
      goyo-vim           # center text
      limelight-vim  # focused writing
  
      # File managing
      nerdtree                       # file system explorer
      nerdtree-git-plugin            # NERDTree git marks
      vim-devicons                   # NERDTree file icons
      vim-nerdtree-syntax-highlight  # highlights filetypes
      ctrlp-vim                      # file fuzyfinder
  
      # easy-writting
      # bracketting
      auto-pairs               # closing brackets
      vim-surround vim-repeat  # changing brackets + dot repetion
      nerdcommenter            # (un)comments text
      # completions
      {
        plugin = deoplete-nvim;
        config = ''
          let g:deoplete#enable_at_startup = 1
        '';
      }
      #unstable.deoplete-tabnine        # tabnine
      deoplete-jedi           # python
      emmet-vim               # html
  
      # syntax highlighting specifics
      vim-nix          # nix
      lf-vim           # lfrc
      vim-markdown     # markdown + latex
      dart-vim-plugin  # dart syntax highlighting
      vim-flutter      # flutter tools
      julia-vim        # julia syntax highlighting
      #vim-cython       # cython filetype and syntax
  
      # under tests
      vim-which-key
      #vim-quick-scope
      ## this installs from git
      #(plugin "neovim/nvim-lspconfig")
      ## this installs the plugin from 'lua' branch
      #(pluginGit "lua" "lukas-reineke/indent-blankline.nvim")
      ## syntax highlighting
      #(plugin "nvim-treesitter/nvim-treesitter")
      #(plugin "p00f/nvim-ts-rainbow") # bracket highlighting
    ];
  };
}
