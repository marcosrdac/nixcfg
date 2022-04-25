{ inputs, overlays }:

with inputs.nixpkgs.lib;
let
  nixpkgs = {
    inherit overlays;
    config = {
      allowUnfree = true;
      #allowBroken = true;
      permittedInsecurePackages = [
        "xpdf-4.03"
      ];
    };
  };

  getHostConfig = { hostname, ... }:
    ../hosts/${hostname}/configuration.nix;

  getUsersHostConfig = { hostname, username, ... }:
    ../users/${username}/hosts/${hostname};

  getSystem = host-and-user: let
    host-config = getHostConfig host-and-user;
    users-host-config = getUsersHostConfig host-and-user;
    nulls = { config = null; pkgs = null; };
  in if pathExists host-config
    then (import host-config nulls).host.system
    else (import users-host-config nulls).host.system;
in

rec {
  mkHost = { hostname }@args: inputs.nixpkgs.lib.nixosSystem rec {
    system = getSystem { inherit hostname; };
    specialArgs = { inherit system hostname inputs; nixos = true; };
    modules = (import ../modules/common)
      ++ (import ../modules/nixos)
      ++ [
        { inherit nixpkgs; }
        ../hosts/${hostname}/configuration.nix
      ];
  };

  mkUser = { username, hostname }@args:
    inputs.home-manager.lib.homeManagerConfiguration rec {
      inherit username;
      system = getSystem args;
      homeDirectory = "/home/${username}";
      extraSpecialArgs = { inherit system hostname inputs; nixos = false; };
      extraModules = (import ../modules/common)
        ++ (import ../modules/home-manager)
        ++ (let c = getUsersHostConfig args; in optional (pathExists c) c)
        ++ [
          {
            inherit nixpkgs;
            programs = {
              home-manager.enable = true;
              git.enable = true;
            };
          }
        ];
      configuration = ../users/${username}/home.nix;
    };
}
