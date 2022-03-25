{ config, pkgs, inputs, ... }:

with inputs.nix-colors.colorSchemes;
with inputs.nix-colors.lib { inherit pkgs; };
{

  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  #colorscheme = solarized-dark;
  colorscheme = tokyonight;
  #colorscheme = dracula;

  #colorscheme = colorschemeFromPicture {
  #  path = ./wallpapers/example.png;
  #  kind = "light";
  #};

  #wallpaper = nixWallpaperFromScheme {
  #  scheme = config.colorscheme;
  #  width = 1920;
  #  height = 1080;
  #  logoScale = 4.0;
  #};
}
