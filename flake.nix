{
  description = "NixOS and Home Manager setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: with builtins; let
    overlays = [ (import ./overlays inputs) ];
    lib = import ./lib { inherit inputs overlays; };
    hosts = attrNames (readDir ./hosts);
    users = attrNames (readDir ./users);
    getExtraHosts = username: let
      user-hosts = ./users/${username}/hosts;
    in
      nixpkgs.lib.optionals (pathExists user-hosts) (attrNames (readDir user-hosts));
    
  in {

    nixosConfigurations = listToAttrs (map (hostname: {
      name = hostname;
      value = lib.mkHost { inherit hostname; };
    }) hosts);

    homeConfigurations = let
      getUserHosts = username: nixpkgs.lib.unique (hosts ++ getExtraHosts username);
      user-host-pairs = nixpkgs.lib.flatten (
        map (username: map (hostname: { inherit hostname username; }) (getUserHosts username)) users
      );
    in
      listToAttrs (map (pair: {
        name = "${pair.hostname}-${pair.username}";
        value = lib.mkUser pair;
      }) user-host-pairs);
  };
}
