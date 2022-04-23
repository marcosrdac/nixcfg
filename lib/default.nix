{ inputs, overlays }:

let
  nixpkgs = {
    inherit overlays;
    config = {
      allowUnfree = true;
      allowBroken = true;  # TODO SPECIFY INSTEAD!
    };
  };
in
{
  mkHost = { hostname }: inputs.nixpkgs.lib.nixosSystem rec {
    system = import ../hosts/${hostname}/system.nix;  # TODO try to import from configuration.nix
    specialArgs = { inherit system hostname inputs; };
    modules = (import ../modules/nixos) ++ [
      { inherit nixpkgs; }
      ../hosts/${hostname}/configuration.nix
    ];
  };

  mkUser =
    { username
    , hostname
    }:
      inputs.home-manager.lib.homeManagerConfiguration rec {
        inherit username;
        system = import ../hosts/${hostname}/system.nix;  # TODO try to import from configuration.nix
        homeDirectory = "/home/${username}";
        extraSpecialArgs = { inherit system hostname inputs; };
        extraModules = (import ../modules/home-manager) ++ [
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
