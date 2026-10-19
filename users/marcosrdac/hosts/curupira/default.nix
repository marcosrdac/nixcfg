{ pkgs, ... }:

{
  # The OCI server has no graphical user session / dconf D-Bus service.
  # Keep dconf management enabled on desktop hosts.
  dconf.enable = false;

  # Codex CLI for development and remote sessions on Curupira.
  home.packages = [ pkgs.unstable.codex ];
}
