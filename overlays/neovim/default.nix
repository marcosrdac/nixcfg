self: pkgs:

pkgs.neovim.override {
    viAlias = true;
    vimAlias = true;

    configure = {

      customRC = let  # find a way to add these to runtime path :S
        en-ascii-spl = builtins.fetchurl {
          url = "http://ftp.vim.org/vim/runtime/spell/en.ascii.spl";
          sha256 = "0j94g27g0wz8icbcrya4rp6mxqqcwa10ad0gjiak7nj5km4bmg6f";
        };
        en-ascii-suggestions = builtins.fetchurl {
          url = "http://ftp.vim.org/vim/runtime/spell/en.ascii.sug";
          sha256 = "0v11f9l8yig4m3vci18p1cs31msa8k5vr5zg91r86pvk37nx1mdh";
        };
        en-latin1-dictionary = builtins.fetchurl {
          url = "http://ftp.vim.org/vim/runtime/spell/en.latin1.spl";
          sha256 = "0i8q2si2bm8c0556j3c0gjin3bixgs055yqqk1irvz4wszy9w3b2";
        };
        en-latin1-suggestions = builtins.fetchurl {
          url = "http://ftp.vim.org/vim/runtime/spell/en.latin1.sug";
          sha256 = "00ibcbj2b2krwd5zl9zl671db44k3fl59sz1yymb9ydkpkj9gpp6";
        };
        en-utf-8-dictionary = builtins.fetchurl {
          url = "http://ftp.vim.org/vim/runtime/spell/en.utf-8.spl";
          sha256 = "0w1h9lw2c52is553r8yh5qzyc9dbbraa57w9q0r9v8xn974vvjpy";
        };
        en-utf-8-suggestions = builtins.fetchurl {
          url = "http://ftp.vim.org/vim/runtime/spell/en.utf-8.sug";
          sha256 = "1v1jr4rsjaxaq8bmvi92c93p4b14x2y1z95zl7bjybaqcmhmwvjv";
        };
        br-latin1-dictionary = builtins.fetchurl {
          url = "http://ftp.vim.org/vim/runtime/spell/br.latin1.spl";
          sha256 = "13nma1zph6lrx8swajjlg9kvjz5f8z8gvz0vj006jmfwcv3q8jxn";
        };
        br-utf-8-dictionary = builtins.fetchurl {
          url = "http://ftp.vim.org/vim/runtime/spell/br.utf-8.spl";
          sha256 = "0k2z0dpxpjzj9b5rsc02l9ii4i7ahvn5r281fzrd3wngzwd6hd0p";
        };
      in
        builtins.concatStringsSep "\n" [
          # use spells in flakes not in runtimepath (some MBs)
          "set runtimepath+=${./runtimepath}"
          # TODO add: if extraconfig then load it (by computer)
          (pkgs.lib.strings.fileContents ./config/base.vim)
          (pkgs.lib.strings.fileContents ./config/mappings.vim)
          (pkgs.lib.strings.fileContents ./config/scripts.vim)
          (pkgs.lib.strings.fileContents ./config/variables.vim)
          (pkgs.lib.strings.fileContents ./config/plugins.vim)
          (pkgs.lib.strings.fileContents ./config/abbreviations.vim)
          (pkgs.lib.strings.fileContents ./config/automation.vim)
        ];

      packages.myVimPackage = with pkgs.vimPlugins;
        let
          unstable = pkgs.unstable.vimPlugins;
	in {
          start = [
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
            nvim-colorizer-lua  # !!!
            vim-hexokinase      # !!!
            #nvim-treesitter    # !!!
        
            # computer language syntax checkers
            ale  # async syntax checking  # !!!
        
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
	    tabnine-vim  # using while deoplete is not working in Nix
	    #deoplete-nvim  # let g:deoplete#enable_at_startup = 1
            #deoplete-tabnine        # tabnine
            #deoplete-jedi           # python
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
          opt = [ ];
      }; 

      vam.pluginDictionaries = [
        { 
          names = [
	    # plugin name strings here
          ];
        }
      ];

    };     
  }
