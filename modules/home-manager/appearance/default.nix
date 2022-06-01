{ config, pkgs, inputs, ... }:

with inputs.nix-colors;
with inputs.nix-colors.lib { inherit pkgs; };
let
  wallpapers = (import ./wallpapers.nix) pkgs;
  fonts = (import ./fonts.nix) pkgs;

  #colorscheme = colorSchemes."3024";
  #colorscheme = colorSchemes."apathy";
  #colorscheme = colorSchemes."apprentice";
  #colorscheme = colorSchemes."ashes";
  #colorscheme = colorSchemes."atelier-cave";
  #colorscheme = colorSchemes."atelier-cave-light";
  #colorscheme = colorSchemes."atelier-dune";
  #colorscheme = colorSchemes."atelier-dune-light";
  #colorscheme = colorSchemes."atelier-estuary";
  #colorscheme = colorSchemes."atelier-estuary-light";
  #colorscheme = colorSchemes."atelier-forest";
  #colorscheme = colorSchemes."atelier-forest-light";
  #colorscheme = colorSchemes."atelier-heath";
  #colorscheme = colorSchemes."atelier-heath-light";
  #colorscheme = colorSchemes."atelier-lakeside";
  #colorscheme = colorSchemes."atelier-lakeside-light";
  #colorscheme = colorSchemes."atelier-plateau";
  #colorscheme = colorSchemes."atelier-plateau-light";
  #colorscheme = colorSchemes."atelier-savanna";
  #colorscheme = colorSchemes."atelier-savanna-light";
  #colorscheme = colorSchemes."atelier-seaside";
  #colorscheme = colorSchemes."atelier-seaside-light";
  #colorscheme = colorSchemes."atelier-sulphurpool";
  #colorscheme = colorSchemes."atelier-sulphurpool-light";
  #colorscheme = colorSchemes."atlas";
  #colorscheme = colorSchemes."ayu-dark";
  #colorscheme = colorSchemes."ayu-light";
  #colorscheme = colorSchemes."ayu-mirage";
  #colorscheme = colorSchemes."bespin";
  #colorscheme = colorSchemes."black-metal";
  #colorscheme = colorSchemes."black-metal-bathory";
  #colorscheme = colorSchemes."black-metal-burzum";
  #colorscheme = colorSchemes."black-metal-dark-funeral";
  #colorscheme = colorSchemes."black-metal-gorgoroth";
  #colorscheme = colorSchemes."black-metal-immortal";
  #colorscheme = colorSchemes."black-metal-khold";
  #colorscheme = colorSchemes."black-metal-marduk";
  #colorscheme = colorSchemes."black-metal-mayhem";
  #colorscheme = colorSchemes."black-metal-nile";
  #colorscheme = colorSchemes."black-metal-venom";
  #colorscheme = colorSchemes."blueforest";
  #colorscheme = colorSchemes."blueish";
  #colorscheme = colorSchemes."brewer";
  #colorscheme = colorSchemes."bright";
  #colorscheme = colorSchemes."brushtrees";
  #colorscheme = colorSchemes."brushtrees-dark";
  #colorscheme = colorSchemes."catppuccin";
  #colorscheme = colorSchemes."chalk";
  #colorscheme = colorSchemes."circus";
  #colorscheme = colorSchemes."classic-dark";
  #colorscheme = colorSchemes."classic-light";
  #colorscheme = colorSchemes."codeschool";
  #colorscheme = colorSchemes."colors";
  #colorscheme = colorSchemes."cupcake";
  #colorscheme = colorSchemes."cupertino";
  #colorscheme = colorSchemes."da-one-black";
  #colorscheme = colorSchemes."da-one-gray";
  #colorscheme = colorSchemes."da-one-ocean";
  #colorscheme = colorSchemes."da-one-paper";
  #colorscheme = colorSchemes."da-one-white";
  #colorscheme = colorSchemes."danqing";
  #colorscheme = colorSchemes."darcula";
  #colorscheme = colorSchemes."darkmoss";
  #colorscheme = colorSchemes."darktooth";
  #colorscheme = colorSchemes."darkviolet";
  #colorscheme = colorSchemes."decaf";
  #colorscheme = colorSchemes."default-dark";
  #colorscheme = colorSchemes."default-light";
  #colorscheme = colorSchemes."dirtysea";
  #colorscheme = colorSchemes."dracula";
  #colorscheme = colorSchemes."eighties";
  #colorscheme = colorSchemes."embers";
  #colorscheme = colorSchemes."emil";
  #colorscheme = colorSchemes."equilibrium-dark";
  #colorscheme = colorSchemes."equilibrium-gray-dark";
  #colorscheme = colorSchemes."equilibrium-gray-light";
  #colorscheme = colorSchemes."equilibrium-light";
  #colorscheme = colorSchemes."espresso";
  #colorscheme = colorSchemes."eva";
  #colorscheme = colorSchemes."eva-dim";
  #colorscheme = colorSchemes."everforest";
  #colorscheme = colorSchemes."flat";
  #colorscheme = colorSchemes."framer";
  #colorscheme = colorSchemes."fruit-soda";
  #colorscheme = colorSchemes."gigavolt";
  #colorscheme = colorSchemes."github";
  #colorscheme = colorSchemes."google-dark";
  #colorscheme = colorSchemes."google-light";
  #colorscheme = colorSchemes."gotham";
  #colorscheme = colorSchemes."grayscale-dark";
  #colorscheme = colorSchemes."grayscale-light";
  #colorscheme = colorSchemes."gruvbox-dark-hard";
  #colorscheme = colorSchemes."gruvbox-dark-medium";
  #colorscheme = colorSchemes."gruvbox-dark-pale";
  #colorscheme = colorSchemes."gruvbox-dark-soft";
  #colorscheme = colorSchemes."gruvbox-light-hard";
  #colorscheme = colorSchemes."gruvbox-light-medium";
  #colorscheme = colorSchemes."gruvbox-light-soft";
  #colorscheme = colorSchemes."gruvbox-material-dark-hard";
  #colorscheme = colorSchemes."gruvbox-material-dark-medium";
  #colorscheme = colorSchemes."gruvbox-material-dark-soft";
  #colorscheme = colorSchemes."gruvbox-material-light-hard";
  #colorscheme = colorSchemes."gruvbox-material-light-medium";
  #colorscheme = colorSchemes."gruvbox-material-light-soft";
  #colorscheme = colorSchemes."hardcore";
  #colorscheme = colorSchemes."harmonic-light";
  #colorscheme = colorSchemes."heetch";
  #colorscheme = colorSchemes."heetch-light";
  #colorscheme = colorSchemes."helios";
  #colorscheme = colorSchemes."hopscotch";
  #colorscheme = colorSchemes."horizon-dark";
  #colorscheme = colorSchemes."horizon-light";
  #colorscheme = colorSchemes."horizon-terminal-dark";
  #colorscheme = colorSchemes."horizon-terminal-light";
  #colorscheme = colorSchemes."humanoid-dark";
  #colorscheme = colorSchemes."humanoid-light";
  #colorscheme = colorSchemes."ia-dark";
  #colorscheme = colorSchemes."ia-light";
  #colorscheme = colorSchemes."icy";
  #colorscheme = colorSchemes."irblack";
  #colorscheme = colorSchemes."isotope";
  #colorscheme = colorSchemes."kanagawa";
  #colorscheme = colorSchemes."katy";
  #colorscheme = colorSchemes."kimber";
  #colorscheme = colorSchemes."lime";
  #colorscheme = colorSchemes."macintosh";
  #colorscheme = colorSchemes."marrakesh";
  #colorscheme = colorSchemes."materia";
  #colorscheme = colorSchemes."material";
  #colorscheme = colorSchemes."material-darker";
  #colorscheme = colorSchemes."material-lighter";
  #colorscheme = colorSchemes."material-palenight";
  #colorscheme = colorSchemes."material-vivid";
  #colorscheme = colorSchemes."mellow-purple";
  #colorscheme = colorSchemes."mexico-light";
  #colorscheme = colorSchemes."mocha";
  #colorscheme = colorSchemes."monokai";
  #colorscheme = colorSchemes."nebula";
  #colorscheme = colorSchemes."nord";
  #colorscheme = colorSchemes."nova";
  #colorscheme = colorSchemes."ocean";
  #colorscheme = colorSchemes."oceanicnext";
  #colorscheme = colorSchemes."one-light";
  #colorscheme = colorSchemes."onedark";
  #colorscheme = colorSchemes."outrun-dark";
  #colorscheme = colorSchemes."pandora";
  #colorscheme = colorSchemes."paraiso";
  #colorscheme = colorSchemes."pasque";
  #colorscheme = colorSchemes."phd";
  #colorscheme = colorSchemes."pico";
  #colorscheme = colorSchemes."pinky";
  #colorscheme = colorSchemes."pop";
  #colorscheme = colorSchemes."porple";
  #colorscheme = colorSchemes."primer-dark";
  #colorscheme = colorSchemes."primer-dark-dimmed";
  #colorscheme = colorSchemes."primer-light";
  #colorscheme = colorSchemes."purpledream";
  #colorscheme = colorSchemes."qualia";
  #colorscheme = colorSchemes."railscasts";
  #colorscheme = colorSchemes."rebecca";
  #colorscheme = colorSchemes."rose-pine";
  #colorscheme = colorSchemes."rose-pine-dawn";
  #colorscheme = colorSchemes."rose-pine-moon";
  #colorscheme = colorSchemes."sagelight";
  #colorscheme = colorSchemes."sakura";
  #colorscheme = colorSchemes."sandcastle";
  #colorscheme = colorSchemes."seti";
  #colorscheme = colorSchemes."shadesmear-dark";
  #colorscheme = colorSchemes."shadesmear-light";
  #colorscheme = colorSchemes."shapeshifter";
  #colorscheme = colorSchemes."silk-dark";
  #colorscheme = colorSchemes."silk-light";
  #colorscheme = colorSchemes."snazzy";
  #colorscheme = colorSchemes."solarflare";
  #colorscheme = colorSchemes."solarflare-light";
  #colorscheme = colorSchemes."solarized-dark";
  #colorscheme = colorSchemes."solarized-light";
  #colorscheme = colorSchemes."spaceduck";
  #colorscheme = colorSchemes."spacemacs";
  #colorscheme = colorSchemes."stella";
  #colorscheme = colorSchemes."still-alive";
  #colorscheme = colorSchemes."summercamp";
  #colorscheme = colorSchemes."summerfruit-dark";
  #colorscheme = colorSchemes."summerfruit-light";
  #colorscheme = colorSchemes."synth-midnight-dark";
  #colorscheme = colorSchemes."synth-midnight-light";
  #colorscheme = colorSchemes."tender";
  #colorscheme = colorSchemes."tokyo-city-dark";
  #colorscheme = colorSchemes."tokyo-city-light";
  #colorscheme = colorSchemes."tokyo-city-terminal-dark";
  #colorscheme = colorSchemes."tokyo-city-terminal-light";
  #colorscheme = colorSchemes."tokyo-night-dark";
  #colorscheme = colorSchemes."tokyo-night-light";
  #colorscheme = colorSchemes."tokyo-night-storm";
  #colorscheme = colorSchemes."tokyo-night-terminal-dark";
  #colorscheme = colorSchemes."tokyo-night-terminal-light";
  #colorscheme = colorSchemes."tokyo-night-terminal-storm";
  #colorscheme = colorSchemes."tokyodark";
  #colorscheme = colorSchemes."tokyodark-terminal";
  #colorscheme = colorSchemes."tokyonight";
  #colorscheme = colorSchemes."tomorrow";
  #colorscheme = colorSchemes."tomorrow-night";
  #colorscheme = colorSchemes."tomorrow-night-eighties";
  #colorscheme = colorSchemes."tube";
  #colorscheme = colorSchemes."twilight";
  #colorscheme = colorSchemes."unikitty-dark";
  #colorscheme = colorSchemes."unikitty-light";
  #colorscheme = colorSchemes."unikitty-reversible";
  #colorscheme = colorSchemes."uwunicorn";
  #colorscheme = colorSchemes."vice";
  #colorscheme = colorSchemes."vulcan";
  #colorscheme = colorSchemes."windows-10-light";
  #colorscheme = colorSchemes."windows-95";
  #colorscheme = colorSchemes."windows-95-light";
  #colorscheme = colorSchemes."windows-highcontrast";
  #colorscheme = colorSchemes."windows-highcontrast-light";
  #colorscheme = colorSchemes."windows-nt";
  #colorscheme = colorSchemes."windows-nt-light";
  #colorscheme = colorSchemes."woodland";
  #colorscheme = colorSchemes."xcode-dusk";
  #colorscheme = colorSchemes."zenburn";
  #colorscheme = colorSchemes."windows-10";

  colorscheme = colorSchemes."harmonic-dark";
  #colorscheme = colorSchemes."harmonic-light";
  #colorscheme = colorSchemes."greenscreen";

  wallpaper = nixWallpaperFromScheme {
    scheme = config.colorscheme;
    width = 1920;
    height = 1080;
    #logoScale = 4.0;
    logoScale = 0;
  };

  #wallpaper = wallpapers.brown-ravine;
  #wallpaper = wallpapers.dark-blue-earth-from-moon;
  #colorscheme = colorschemeFromPicture {
  #  path = wallpaper;
  #  kind = "dark";
  #};
in
{
  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  services.redshift = {
    enable = true;
    latitude = -12.97;
    longitude = -38.50;
  };

  colorscheme = colorscheme;

  home.file = {
    wallpaper = {
      target = "${config.xdg.dataHome}/appearance/wallpaper";
      source = wallpaper;
      onChange = ''
        ${pkgs.feh}/bin/feh --bg-scale ${wallpaper} &
      '';
    };
    xsettingsdrc = {
      target = "${config.xdg.dataHome}/appearance/xsettingsdrc";
      text = ''Net/ThemeName "${config.colorscheme.slug}"'';
      onChange = ''
        ${pkgs.xsettingsd}/bin/xsettingsd \
          -c ${config.xdg.dataHome}/appearance/xsettingsdrc 2>/dev/null &
        (sleep .2 && kill $!) &
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
