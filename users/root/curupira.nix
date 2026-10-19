{ pkgs, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "24.05";

  # Reuse the same Zsh and Starship modules as the regular user.
  imports = [
    ../../modules/home-manager/shell/zsh
    ../../modules/home-manager/shell/starship
  ];

  # No graphical user session on the OCI server.
  dconf.enable = false;

  # Show hostname in root prompts even after sudo/su drops SSH context.
  programs.starship.settings = {
    hostname.ssh_only = false;
    character = {
      success_symbol = "[#](bold red)";
      error_symbol = "[#](bold red)";
      vicmd_symbol = "[#](bold red)";
    };
  };

  home.shellAliases = {
    hm = "home-manager --flake /etc/nixos#curupira-root";
    hms = "home-manager switch --flake /etc/nixos#curupira-root";
    nrs = "nixos-rebuild switch --flake /etc/nixos#curupira";
  };
}
