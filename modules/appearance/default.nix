{ config, pkgs, inputs, ... }:

with inputs.nix-colors;
with inputs.nix-colors.lib { inherit pkgs; };
let
  wallpapers = (import ./wallpapers.nix) pkgs;
  fonts = (import ./fonts.nix) pkgs;

  #colorscheme = colorSchemes.dracula;
  #wallpaper = nixWallpaperFromScheme {
  #  scheme = config.colorscheme;
  #  width = 1920;
  #  height = 1080;
  #  #logoScale = 4.0;
  #  logoScale = 0;
  #};

  #wallpaper = wallpapers.brown-ravine;
  wallpaper = wallpapers.green-machu-pichu;
  colorscheme = colorschemeFromPicture {
    path = wallpaper;
    kind = "dark";
  };
in
{
  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  colorscheme = colorscheme;

  home.file = {
    "${config.xdg.dataHome}/appearance/wallpaper" = {
      source = wallpaper;
      onChange = ''
        ${pkgs.feh}/bin/feh --bg-scale ${wallpaper}
      '';
    };
  };

  gtk = {
    enable = true;
    #font = fonts.spleen;
    theme = {
      name = "${config.colorscheme.slug}";
      package = gtkThemeFromScheme {
        scheme = config.colorscheme;
      };
    };
    iconTheme = null;
    #cursorTheme = null;
  };

  #ExecStart = "${pkgs.feh}/bin/feh ${flags} ${cfg.imageDirectory}"

  #activationScript = pkgs.writeShellScript "activation-script" ''
  #        set -eu
  #        set -o pipefail
  #        cd $HOME
  #        export PATH="${activationBinPaths}"
  #        ${config.lib.bash.initHomeManagerLib}
  #        ${builtins.readFile ./lib-bash/activation-init.sh}
  #        ${activationCmds}
  #      '';
  #    in
  #      pkgs.runCommand
  #        "home-manager-generation"
  #        {
  #          preferLocalBuild = true;
  #        }
  #        ''
  #          mkdir -p $out
  #          cp ${activationScript} $out/activate
  #          mkdir $out/bin
  #          ln -s $out/activate $out/bin/home-manager-generation
  #          substituteInPlace $out/activate \
  #            --subst-var-by GENERATION_DIR $out
  #          ln -s ${config.home-files} $out/home-files
  #          ln -s ${cfg.path} $out/home-path
  #          ${cfg.extraBuilderCommands}
  #        '';
}
