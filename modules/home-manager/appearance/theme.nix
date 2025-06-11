{ config, pkgs, inputs, ... }:

with inputs.nix-colors;
with inputs.nix-colors.lib;
with inputs.nix-colors.lib.contrib { inherit pkgs; };
let
  wallpapers = (import ./wallpapers.nix) pkgs;
  fonts = (import ./fonts.nix) pkgs;

  #colorScheme = colorSchemes."apathy";
  #colorScheme = colorSchemes."apprentice";
  #colorScheme = colorSchemes."ashes";
  #colorScheme = colorSchemes."atelier-cave";
  #colorScheme = colorSchemes."atelier-cave-light";
  #colorScheme = colorSchemes."atelier-dune";
  #colorScheme = colorSchemes."atelier-dune-light";
  #colorScheme = colorSchemes."atelier-estuary";
  #colorScheme = colorSchemes."atelier-estuary-light";
  #colorScheme = colorSchemes."atelier-forest";
  #colorScheme = colorSchemes."atelier-forest-light";
  #colorScheme = colorSchemes."atelier-heath";
  #colorScheme = colorSchemes."atelier-heath-light";
  #colorScheme = colorSchemes."atelier-lakeside";
  #colorScheme = colorSchemes."atelier-lakeside-light";
  #colorScheme = colorSchemes."atelier-plateau";
  #colorScheme = colorSchemes."atelier-plateau-light";
  #colorScheme = colorSchemes."atelier-savanna";
  #colorScheme = colorSchemes."atelier-savanna-light";
  #colorScheme = colorSchemes."atelier-seaside";
  #colorScheme = colorSchemes."atelier-seaside-light";
  #colorScheme = colorSchemes."atelier-sulphurpool";
  #colorScheme = colorSchemes."atelier-sulphurpool-light";
  #colorScheme = colorSchemes."atlas";
  #colorScheme = colorSchemes."ayu-dark";
  #colorScheme = colorSchemes."ayu-light";
  #colorScheme = colorSchemes."ayu-mirage";
  #colorScheme = colorSchemes."bespin";
  #colorScheme = colorSchemes."black-metal";
  #colorScheme = colorSchemes."black-metal-bathory";
  #colorScheme = colorSchemes."black-metal-burzum";
  #colorScheme = colorSchemes."black-metal-dark-funeral";
  #colorScheme = colorSchemes."black-metal-gorgoroth";
  #colorScheme = colorSchemes."black-metal-immortal";
  #colorScheme = colorSchemes."black-metal-khold";
  #colorScheme = colorSchemes."black-metal-marduk";
  #colorScheme = colorSchemes."black-metal-mayhem";
  #colorScheme = colorSchemes."black-metal-nile";
  #colorScheme = colorSchemes."black-metal-venom";
  #colorScheme = colorSchemes."blueforest";
  #colorScheme = colorSchemes."blueish";
  #colorScheme = colorSchemes."brewer";
  #colorScheme = colorSchemes."bright";
  #colorScheme = colorSchemes."brushtrees";
  #colorScheme = colorSchemes."brushtrees-dark";
  #colorScheme = colorSchemes."catppuccin";
  #colorScheme = colorSchemes."chalk";
  #colorScheme = colorSchemes."circus";
  #colorScheme = colorSchemes."classic-dark";
  #colorScheme = colorSchemes."classic-light";
  #colorScheme = colorSchemes."codeschool";
  #colorScheme = colorSchemes."colors";
  #colorScheme = colorSchemes."cupcake";
  #colorScheme = colorSchemes."cupertino";
  #colorScheme = colorSchemes."da-one-black";
  #colorScheme = colorSchemes."da-one-gray";
  #colorScheme = colorSchemes."da-one-ocean";
  #colorScheme = colorSchemes."da-one-paper";
  #colorScheme = colorSchemes."da-one-white";
  #colorScheme = colorSchemes."danqing";
  #colorScheme = colorSchemes."darcula";
  #colorScheme = colorSchemes."darkmoss";
  #colorScheme = colorSchemes."darktooth";
  #colorScheme = colorSchemes."darkviolet";
  #colorScheme = colorSchemes."decaf";
  #colorScheme = colorSchemes."default-dark";
  #colorScheme = colorSchemes."default-light";
  #colorScheme = colorSchemes."dirtysea";
  #colorScheme = colorSchemes."dracula";
  #colorScheme = colorSchemes."eighties";
  #colorScheme = colorSchemes."embers";
  #colorScheme = colorSchemes."emil";
  #colorScheme = colorSchemes."equilibrium-dark";
  #colorScheme = colorSchemes."equilibrium-gray-dark";
  #colorScheme = colorSchemes."equilibrium-gray-light";
  #colorScheme = colorSchemes."equilibrium-light";
  #colorScheme = colorSchemes."espresso";
  #colorScheme = colorSchemes."eva";
  #colorScheme = colorSchemes."eva-dim";
  #colorScheme = colorSchemes."everforest";
  #colorScheme = colorSchemes."flat";
  #colorScheme = colorSchemes."framer";
  #colorScheme = colorSchemes."fruit-soda";
  #colorScheme = colorSchemes."gigavolt";
  #colorScheme = colorSchemes."github";
  #colorScheme = colorSchemes."google-dark";
  #colorScheme = colorSchemes."google-light";
  #colorScheme = colorSchemes."gotham";
  #colorScheme = colorSchemes."grayscale-dark";
  #colorScheme = colorSchemes."grayscale-light";
  #colorScheme = colorSchemes."gruvbox-dark-hard";
  #colorScheme = colorSchemes."gruvbox-dark-medium";
  #colorScheme = colorSchemes."gruvbox-dark-pale";
  #colorScheme = colorSchemes."gruvbox-dark-soft";
  #colorScheme = colorSchemes."gruvbox-light-hard";
  #colorScheme = colorSchemes."gruvbox-light-medium";
  #colorScheme = colorSchemes."gruvbox-light-soft";
  #colorScheme = colorSchemes."gruvbox-material-dark-hard";
  #colorScheme = colorSchemes."gruvbox-material-dark-medium";
  #colorScheme = colorSchemes."gruvbox-material-dark-soft";
  #colorScheme = colorSchemes."gruvbox-material-light-hard";
  #colorScheme = colorSchemes."gruvbox-material-light-medium";
  #colorScheme = colorSchemes."gruvbox-material-light-soft";
  #colorScheme = colorSchemes."hardcore";
  #colorScheme = colorSchemes."harmonic-light";
  #colorScheme = colorSchemes."heetch";
  #colorScheme = colorSchemes."heetch-light";
  #colorScheme = colorSchemes."helios";
  #colorScheme = colorSchemes."hopscotch";
  #colorScheme = colorSchemes."horizon-dark";
  #colorScheme = colorSchemes."horizon-light";
  #colorScheme = colorSchemes."horizon-terminal-dark";
  #colorScheme = colorSchemes."horizon-terminal-light";
  #colorScheme = colorSchemes."humanoid-dark";
  #colorScheme = colorSchemes."humanoid-light";
  #colorScheme = colorSchemes."ia-dark";
  #colorScheme = colorSchemes."ia-light";
  #colorScheme = colorSchemes."icy";
  #colorScheme = colorSchemes."irblack";
  #colorScheme = colorSchemes."isotope";
  #colorScheme = colorSchemes."kanagawa";
  #colorScheme = colorSchemes."katy";
  #colorScheme = colorSchemes."kimber";
  #colorScheme = colorSchemes."lime";
  #colorScheme = colorSchemes."macintosh";
  #colorScheme = colorSchemes."marrakesh";
  #colorScheme = colorSchemes."materia";
  #colorScheme = colorSchemes."material";
  #colorScheme = colorSchemes."material-darker";
  #colorScheme = colorSchemes."material-lighter";
  #colorScheme = colorSchemes."material-palenight";
  #colorScheme = colorSchemes."material-vivid";
  #colorScheme = colorSchemes."mellow-purple";
  #colorScheme = colorSchemes."mexico-light";
  #colorScheme = colorSchemes."mocha";
  #colorScheme = colorSchemes."monokai";
  #colorScheme = colorSchemes."nebula";
  #colorScheme = colorSchemes."nord";
  #colorScheme = colorSchemes."nova";
  #colorScheme = colorSchemes."ocean";
  #colorScheme = colorSchemes."oceanicnext";
  #colorScheme = colorSchemes."one-light";
  #colorScheme = colorSchemes."onedark";
  #colorScheme = colorSchemes."outrun-dark";
  #colorScheme = colorSchemes."pandora";
  #colorScheme = colorSchemes."paraiso";
  #colorScheme = colorSchemes."pasque";
  #colorScheme = colorSchemes."phd";
  #colorScheme = colorSchemes."pico";
  #colorScheme = colorSchemes."pinky";
  #colorScheme = colorSchemes."pop";
  #colorScheme = colorSchemes."porple";
  #colorScheme = colorSchemes."primer-dark";
  #colorScheme = colorSchemes."primer-dark-dimmed";
  #colorScheme = colorSchemes."primer-light";
  #colorScheme = colorSchemes."purpledream";
  #colorScheme = colorSchemes."qualia";
  #colorScheme = colorSchemes."railscasts";
  #colorScheme = colorSchemes."rebecca";
  #colorScheme = colorSchemes."rose-pine";
  #colorScheme = colorSchemes."rose-pine-dawn";
  #colorScheme = colorSchemes."rose-pine-moon";
  #colorScheme = colorSchemes."sagelight";
  #colorScheme = colorSchemes."sakura";
  #colorScheme = colorSchemes."sandcastle";
  #colorScheme = colorSchemes."seti";
  #colorScheme = colorSchemes."shadesmear-dark";
  #colorScheme = colorSchemes."shadesmear-light";
  #colorScheme = colorSchemes."shapeshifter";
  #colorScheme = colorSchemes."silk-dark";
  #colorScheme = colorSchemes."silk-light";
  #colorScheme = colorSchemes."snazzy";
  #colorScheme = colorSchemes."solarflare";
  #colorScheme = colorSchemes."solarflare-light";
  #colorScheme = colorSchemes."solarized-dark";
  #colorScheme = colorSchemes."solarized-light";
  #colorScheme = colorSchemes."spaceduck";
  #colorScheme = colorSchemes."spacemacs";
  #colorScheme = colorSchemes."stella";
  #colorScheme = colorSchemes."still-alive";
  #colorScheme = colorSchemes."summercamp";
  #colorScheme = colorSchemes."summerfruit-dark";
  #colorScheme = colorSchemes."summerfruit-light";
  #colorScheme = colorSchemes."synth-midnight-dark";
  #colorScheme = colorSchemes."synth-midnight-light";
  #colorScheme = colorSchemes."tender";
  #colorScheme = colorSchemes."tokyo-city-dark";
  #colorScheme = colorSchemes."tokyo-city-light";
  #colorScheme = colorSchemes."tokyo-city-terminal-dark";
  #colorScheme = colorSchemes."tokyo-city-terminal-light";
  #colorScheme = colorSchemes."tokyo-night-dark";
  #colorScheme = colorSchemes."tokyo-night-light";
  #colorScheme = colorSchemes."tokyo-night-storm";
  #colorScheme = colorSchemes."tokyo-night-terminal-dark";
  #colorScheme = colorSchemes."tokyo-night-terminal-light";
  #colorScheme = colorSchemes."tokyo-night-terminal-storm";
  #colorScheme = colorSchemes."tokyodark";
  #colorScheme = colorSchemes."tokyodark-terminal";
  #colorScheme = colorSchemes."tokyonight";
  #colorScheme = colorSchemes."tomorrow";
  #colorScheme = colorSchemes."tomorrow-night";
  #colorScheme = colorSchemes."tomorrow-night-eighties";
  #colorScheme = colorSchemes."tube";
  #colorScheme = colorSchemes."twilight";
  #colorScheme = colorSchemes."unikitty-dark";
  #colorScheme = colorSchemes."unikitty-reversible";
  #colorScheme = colorSchemes."uwunicorn";
  #colorScheme = colorSchemes."vice";
  #colorScheme = colorSchemes."vulcan";
  #colorScheme = colorSchemes."windows-10-light";
  #colorScheme = colorSchemes."windows-95";
  #colorScheme = colorSchemes."windows-95-light";
  #colorScheme = colorSchemes."windows-highcontrast";
  #colorScheme = colorSchemes."windows-highcontrast-light";
  #colorScheme = colorSchemes."windows-nt";
  #colorScheme = colorSchemes."windows-nt-light";
  #colorScheme = colorSchemes."xcode-dusk";
  #colorScheme = colorSchemes."zenburn";
  #colorScheme = colorSchemes."windows-10";
  #colorScheme = colorSchemes."woodland";

  #colorScheme = colorSchemes."3024";
  colorScheme = colorSchemes."harmonic16-dark";
  #colorScheme = colorSchemes."harmonic-light";
  #colorScheme = colorSchemes."greenscreen";
  #colorScheme = colorSchemes."unikitty-light";

  wallpaper = nixWallpaperFromScheme {
    scheme = config.colorScheme;
    width = 1920;
    height = 1080;
    #logoScale = 4.0;
    logoScale = 0;
  };

  #wallpaper = wallpapers.brown-ravine;
  #wallpaper = wallpapers.dark-blue-earth-from-moon;
  #colorScheme = colorSchemeFromPicture {
  #  path = wallpaper;
  #  kind = "dark";
  #};
in
{
  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  #services.redshift = {
  #  enable = true;
  #  latitude = -12.97;
  #  longitude = -38.50;
  #};

  colorScheme = colorScheme;

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
      text = ''Net/ThemeName "${config.colorScheme.slug}"'';
      onChange = ''
        ${pkgs.xsettingsd}/bin/xsettingsd \
          -c ${config.xdg.dataHome}/appearance/xsettingsdrc 2>/dev/null &
        (sleep .2 && kill $!) &
      '';
    };
  };

  gtk = {
    enable = true;
    font = fonts.iosevka;
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme {
        scheme = config.colorScheme;
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
