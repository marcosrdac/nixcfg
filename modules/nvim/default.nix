{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotDir = "${config.xdg.configHome}/nixpkgs";
  dotConfig = "${dotDir}/config";
  dotBin = "${dotDir}/bin";
  nvimConfig = "${config.xdg.configHome}/nvim";
in
{
  xdg.configFile = with config.lib.file; {
    "nvim/base.vim".source = mkOutOfStoreSymlink "${dotConfig}/nvim/base.vim";
    "nvim/mappings.vim".source = mkOutOfStoreSymlink "${dotConfig}/nvim/base.vim";
    "nvim/scripts.vim".source = mkOutOfStoreSymlink "${dotConfig}/nvim/scripts.vim";
    "nvim/abbreviations.vim".source = mkOutOfStoreSymlink "${dotConfig}/nvim/abbreviations.vim";
    "nvim/variables.vim".source = mkOutOfStoreSymlink "${dotConfig}/nvim/variables.vim";
    "nvim/automation.vim".source = mkOutOfStoreSymlink "${dotConfig}/nvim/automation.vim";
    "nvim/plugins.vim".source = mkOutOfStoreSymlink "${dotConfig}/nvim/plugins.vim";
    "nvim/autoload".source = mkOutOfStoreSymlink "${dotConfig}/nvim/autoload";
    "nvim/spell".source = mkOutOfStoreSymlink "${dotConfig}/nvim/spell";
    "nvim/colors".source = mkOutOfStoreSymlink "${dotConfig}/nvim/colors";
    "nvim/ftplugin".source = mkOutOfStoreSymlink "${dotConfig}/nvim/ftplugin";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        " source config files
        let g:vimpath = expand('$XDG_CONFIG_HOME/nvim')
        exec 'source '.g:vimpath.'/base.vim'
        exec 'source '.g:vimpath.'/mappings.vim'
        exec 'source '.g:vimpath.'/scripts.vim'
        exec 'source '.g:vimpath.'/variables.vim'
        exec 'source '.g:vimpath.'/plugins.vim'
        exec 'source '.g:vimpath.'/abbreviations.vim'
        exec 'source '.g:vimpath.'/automation.vim'
      ''
      # TODO add if extraconfig then load it (by computer)
      #(lib.strings.fileContents ./base.vim)
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
  
    plugins = with pkgs.vimPlugins; [
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
      deoplete-nvim     # base deoplete
      deoplete-tabnine  # tabnine
      deoplete-jedi     # python
      emmet-vim         # html
  
      # syntax highlighting for different filetypes
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
