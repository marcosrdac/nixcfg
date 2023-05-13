{
  description = "NixOS and Home Manager setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    #nixpkgs-17 = { url = "github:NixOS/nixpkgs/17.09"; flake = false; };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: with builtins; let
    lib = import ./lib { inherit inputs; };
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
      }) (builtins.trace "./" user-host-pairs));

    repositoryRoot = /.;
    
    aarch64-linux.homeConfigurations = self.homeConfigurations;
  };
}
