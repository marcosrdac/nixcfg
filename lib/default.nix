{ inputs, overlays }:

{
  mkSystem =
    { hostname
    , system }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit system hostname inputs; };
        modules = builtins.attrValues (import ../modules/nixos) ++ [
          ../hosts/${hostname}/configuration.nix

          {
            nixpkgs = {
              overlays = overlays;
              config.allowUnfree = true;
            };
          }
        ];
      };

  mkHome =
    { username
    , system
    , hostname
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit username system;
        extraSpecialArgs = {
          inherit system hostname inputs;
        };
        homeDirectory = "/home/${username}";
        configuration = ../users/${username}/home;
        extraModules = builtins.attrValues (import ../modules/home-manager) ++ [
          # Base configuration
          {
            nixpkgs = {
              inherit overlays;
              config.allowUnfree = true;
            };
            programs = {
              home-manager.enable = true;
              git.enable = true;
            };
            systemd.user.startServices = "sd-switch";
          }
        ];
      };
}
