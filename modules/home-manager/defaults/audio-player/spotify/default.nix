{ pkgs, ... }:

{
  # Spotify provides no aarch64-linux package. Keep it on supported hosts.
  home.packages = pkgs.lib.optionals
    (pkgs.stdenv.hostPlatform.system != "aarch64-linux")
    [ pkgs.spotify ];
}
