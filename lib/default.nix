{ inputs, overlays }:

let
  nixpkgs = {
    inherit overlays;
    config = {
      allowUnfree = true;
      allowBroken = true;  # TODO SPECIFY INSTEAD!
    };
  };
  getSystem = {hostname ? null, username ? null }: let
    host-configuration = ../hosts/${hostname}/configuration.nix;
    nullInputs = { config = null; pkgs = null; };
  in if builtins.pathExists host-configuration
    then (import host-configuration nullInputs).hostConfig.machine.system
    else (import ../users/${username}/hosts/${hostname} nullInputs).system;
in rec {

  mkHost = { hostname }: inputs.nixpkgs.lib.nixosSystem rec {
    system = getSystem { inherit hostname; };
    specialArgs = { inherit system hostname inputs; };
    modules = #(import ../modules/common) ++
      (import ../modules/nixos)
      ++ [
        { inherit nixpkgs; }
        ../hosts/${hostname}/configuration.nix
      ];
  };

  mkUser = { username , hostname }:
    inputs.home-manager.lib.homeManagerConfiguration rec {
      inherit username;
      system = getSystem { inherit hostname username; };
      homeDirectory = "/home/${username}";
      extraSpecialArgs = { inherit system hostname inputs; };
      extraModules = (import ../modules/common)
        ++ (import ../modules/home-manager)
        ++ [
          {
            inherit nixpkgs;
            programs = {
              #home-manager.enable = true;
              #git.enable = true;
            };
          }
        ];
      configuration = ../users/${username}/home.nix;
    };
}
