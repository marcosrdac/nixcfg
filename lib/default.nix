{ inputs, ... }:

with inputs.nixpkgs.lib;
let
  flakeDir = ../.;
  nixpkgsConfig = import ./nixpkgs.nix { inherit inputs; };

  getHostConfig = { hostname, ... }:
    ../hosts/${hostname}/configuration.nix;

  getUsersHostConfig = { hostname, username, ... }:
    ../users/${username}/hosts/${hostname};

  getSystem = host-and-user: let
    host-config = getHostConfig host-and-user;
    users-host-config = getUsersHostConfig host-and-user;
    nulls = { config = null; pkgs = null; modulesPath = null; };
  in if pathExists host-config
    then (import host-config nulls).host.system
    else (import users-host-config nulls).host.system;
in
rec {
  mkHost = { hostname }@args: inputs.nixpkgs.lib.nixosSystem rec {
    system = getSystem { inherit hostname; };
    specialArgs = { inherit system hostname inputs flakeDir; isNixos = true;};
    modules = (import ../modules/common)
      ++ (import ../modules/nixos)
      ++ [
        { nixpkgs = nixpkgsConfig; }
        inputs.sops-nix.nixosModules.sops
        ../hosts/${hostname}/configuration.nix
      ];
  };

  mkUser = { username, hostname }@args: let
    system = getSystem args;
  in inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit system hostname inputs flakeDir; isNixos = false; };
      modules = (import ../modules/common)
        ++ (import ../modules/home-manager)
        ++ (let c = getUsersHostConfig args; in optional (pathExists c) c)
        ++ [
          { nixpkgs = nixpkgsConfig; }
          { programs.git.enable = true; }
          inputs.sops-nix.homeManagerModules.sops
          ../users/${username}/home.nix 
        ];
    };
}

# THOUGHT: "isNixos" could be "asSystem"
