{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    homeConfigurations = rec {
      adam-marcosrdac = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        stateVersion = "21.11";
        username = "marcosrdac";
        homeDirectory = "/home/marcosrdac";
        extraSpecialArgs = { inherit inputs; };
        configuration = { config, pkgs, ... }: {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowBroken = true;
            };
            overlays = [ (import ./overlays inputs) ];
          };
          imports = [ ./home.nix ];
        };
      };
    };

    defaultPackage.x86_64-linux = self.homeConfigurations.adam-marcosrdac.activationPackage;
  };
}
