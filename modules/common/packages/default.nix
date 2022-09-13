{ config, pkgs, inputs, nixos, system, ... }:

with pkgs.lib;
let
  cfg = config.packages;
in
{
  options.packages = {
    list = mkOption {
      description = "Extra packages to be installed";
      type = with types; listOf package;
      default = [ ];
      example = literalExpression ''[ pkgs.inkscape ]'';
    };

    basic = mkEnableOption "Install default basic packages?";
    design = mkEnableOption "Install default design packages?";
  };

  config = with pkgs; let 
    basic-packages = [
      acpi  # TODO useful for notebooks, should be separated from basic
      ventoy-bin  # TODO bootable flash drive
      gparted
      pptp
      alacritty  # TODO not useful for servers... another group for this one here
      at
      bc
      curl
      file
      firefox
      fzy
      git
      jq
      keepassx2
      killall
      lf
      libnotify
      ncdu
      neofetch
      neovim
      nix-index
      nixpkgs-fmt
      nixpkgs-review
      nox
      ntfs3g
      p7zip
      pciutils
      ripgrep
      tmux
      unzip
      usbutils
      wget
      zip  # this is truly basic

      # needed?
      singularity
      containerd
    ];
    design-packages = [
      gimp
      inkscape
    ];
    packages = (
      cfg.list
      ++ [ inputs.home-manager.packages.${system}.home-manager ]
      ++ (optionals cfg.basic basic-packages)
      ++ (optionals cfg.design design-packages)
    );
  in
    if nixos then {
      environment.systemPackages = packages;
      
      programs.neovim = {
        enable = true;
        #package = pkgs.neovim;
        viAlias = true;
        vimAlias = true;
      };

    } else {
      home.packages = packages ++ [pkgs.krita];
    };
}
