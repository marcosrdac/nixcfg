{ config, pkgs, inputs, nixos, system, ... }:

with pkgs.lib;
let
  cfg = config.packages;
in
{
  options.packages = {
    enable = mkEnableOption "Enable default package management";

    basic = mkOption {
      description = "Install default basic packages?";
      type = with types; bool;
      default = true;
    };

    design = mkEnableOption "Install default design packages?";

    extra = mkOption {
      description = "Extra packages to be installed";
      type = with types; listOf package;
      default = [ ];
      example = literalExpression ''[ pkgs.inkscape ]'';
    };

  };

  config = with pkgs; let 
    basic-packages = [
      acpi
      alacritty
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
      neofetch
      neovim
      nox
      ntfs3g
      p7zip
      pciutils
      ripgrep
      tmux
      unzip
      usbutils
      wget
      zip
    ];
    design-packages = [
      gimp
      inkscape
    ];
    packages = optionals cfg.enable (
      [ inputs.home-manager.packages.${system}.home-manager ]
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
