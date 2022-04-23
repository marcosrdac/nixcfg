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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      overlay = import ./overlay inputs;

      lib = import ./lib { inherit inputs overlays; };

      hostsConfigs = (
        dir: builtins.listToAttrs (
          map (host: {
            name = host;
            value = dir + "/${host}/configuration.nix";
          }) (builtins.attrNames (builtins.readDir dir)))
      ) ./hosts;
      nixosModules = (
        dir: map (mod: dir + "/${mod}")
          (builtins.attrNames (builtins.readDir dir))
      ) ./lib/modules;
      mkHost = hostConfig:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";  # how to get from host?
          specialArgs = inputs;
          modules = overlayModules ++ nixosModules ++ [ hostConfig ];
        };
    in {
      nixosConfigurations = builtins.mapAttrs
        (host: config: mkHost config) hostsConfigs;

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
