{ inputs }:

with inputs.nixpkgs.lib;
{
  config = {
    #allowBroken = false;
    #allowUnfree = false;
    allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "cudatoolkit"
      "steam"
      "steam-original"
      "unrar"
      "discord"
      "slack"
      "teams"
      "zoom"
      "spotify"
      "spotify-unwrapped"
      "write_stylus"
      "corefonts"
      "google-chrome"
      "dropbox"
    ];
    permittedInsecurePackages = [
      "xpdf-4.04"
    ];
  };

  overlays = let
    overlay = import ../overlays { inherit inputs; };

    sources = final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.system;
        config = {
          allowUnfree = final.config.allowUnfree;
          allowBroken = final.config.allowBroken;
          allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
            "write_stylus"
          ];
        };
      };
      nur = import inputs.nur {
        pkgs = prev;
        nurpkgs = prev;
        repoOverrides = {
          #paul = import paul { pkgs = prev; };
        };
      };
    };
  in [
    sources
    overlay
  ];
}
