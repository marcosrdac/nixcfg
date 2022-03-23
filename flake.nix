{
  description = "Home Manager NixOS configuration";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nur, home-manager, ... }:
    let
      importChildren = (
        dir: map (mod: import (dir + "/${mod}"))
          (builtins.attrNames (builtins.readDir dir))
      );
    in {
      homeConfigurations = rec {
        # convenient workaround for unneeded "--flake ~/.config/nixpkgs#adam"
        marcosrdac = adam;  

        # user configuration by system
        adam = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          stateVersion = "21.11";

          username = "marcosrdac";
          homeDirectory = "/home/marcosrdac";

          configuration = { config, pkgs, ... }:
            let
              unstable-overlay = self: pkgs: {
                unstable = import inputs.nixpkgs-unstable {
                  system = pkgs.system;
                  config.allowUnfree = true;
		};
              };
              external-overlays = [ unstable-overlay nur.overlay ];
              internal-overlays = importChildren ./overlays;
            in
              {
                nixpkgs.overlays = external-overlays ++ internal-overlays;
                nixpkgs.config = {
                  allowUnfree = true;
                  allowBroken = true;
                };
                imports = [ ./home.nix ]; # ./users/marcosrdac/home.nix 
              };
        };
      };

      defaultPackage.x86_64-linux = self.homeConfigurations.adam.activationPackage;
    };
}
