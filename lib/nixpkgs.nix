{ inputs }:

with inputs.nixpkgs.lib;
{
  config = {
    #allowBroken = false;
    #allowUnfree = false;
    allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "cudatoolkit"
      "steam"
      "steam-run"
      "steam-original"
      "steam-unwrapped"
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
      "vmware-horizon-client"
      "styluslabs-write-bin"
      "stremio-shell"
      "stremio-server"
    ];
    permittedInsecurePackages = [
      "xpdf-4.05"
      "qtwebkit-5.212.0-alpha4"
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

      #nixpkgs-24-05 = import inputs.nixpkgs-24-05 {
      #  system = prev.system;
      #  config = {
      #    allowUnfree = final.config.allowUnfree;
      #    allowBroken = final.config.allowBroken;
      #    allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
      #      "write_stylus"
      #    ];
      #  };
      #};

    };
  in [
    sources
    overlay
  ];
}
