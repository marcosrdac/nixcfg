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
      overlays = [ (import ./overlays inputs) ];
      lib = import ./lib { inherit inputs overlays; };
      getExtraHosts = username: let
        user-hosts = ./users/${username}/hosts;
      in
        if (builtins.pathExists user-hosts) 
        then (builtins.attrNames (builtins.readDir user-hosts))
        else [];
      hosts = builtins.attrNames (builtins.readDir ./hosts);
      users = builtins.attrNames (builtins.readDir ./users);
    in {
      nixosConfigurations = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = lib.mkHost { inherit hostname; };
      }) hosts);
      homeConfigurations = let
        #hostUserPairs = nixpkgs.lib.lists.flatten (
        #  map (hostname: map (username: { inherit hostname username; }) users) hosts
        #);
        hostUserPairs = nixpkgs.lib.lists.flatten (
          map (username: map (hostname: { inherit hostname username; }) (nixpkgs.lib.lists.unique (hosts ++ (getExtraHosts username))) ) users
        );
      in
        builtins.listToAttrs (map (pair: {
          name = "${pair.hostname}-${pair.username}";
          value = lib.mkUser pair;
        }) hostUserPairs);
    };
}
