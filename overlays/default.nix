{ inputs }:

final: prev: {
  nix = final.unstable.nix;

  # outer overlays
  polybar = final.unstable.polybar;  # colors = ~/.config/polybar/colors

  # inner overlays
  neovim = import ./neovim final prev;
  write_stylus = import ./write_stylus final prev;
  networkmanager-vpnc = import ./networkmanager/plugins/vtnc final prev;
  networkmanager-pptp = import ./networkmanager/plugins/pptp final prev;

  #markserv = pkgs.stdenv.mkDerivation {
  #  name = "markserv";
  #  src = ./my-app;
  #  buildInputs = [nodejs];
  #  buildPhase = let
  #    
  #  in ''
  #    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
  #    export PATH="${nodeDependencies}/bin:$PATH"

  #    # Build the distribution bundle in "dist"
  #    webpack
  #    cp -r dist $out/
  #  '';
  #};
}
