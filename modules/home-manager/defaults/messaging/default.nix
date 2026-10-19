{ pkgs, ... }:

{
  home.packages = with pkgs;
    [ telegram-desktop ]
    ++ lib.optionals (stdenv.hostPlatform.system != "aarch64-linux") [
      slack
      zoom-us
    ];
}
