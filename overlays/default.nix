{ inputs }:

final: prev: {
  nix = final.unstable.nix;

  # outer overlays
  polybar = final.unstable.polybar;  # colors = ~/.config/polybar/colors

  # inner overlays
  neovim = import ./neovim final prev;
  write_stylus = import ./write_stylus final prev;
  #networkmanager-vpnc = import ./networkmanager/plugins/vtnc final prev;
  #networkmanager-pptp = import ./networkmanager/plugins/pptp final prev;

  discord = prev.discord.overrideAttrs (_: { src = builtins.fetchTarball {
    url = "https://discord.com/api/download/stable?platform=linux&format=tar.gz";
    sha256 = "sha256:0mr1az32rcfdnqh61jq7jil6ki1dpg7bdld88y2jjfl2bk14vq4s";};
  });

  #with import <nixpkgs> { };
  swhkd = with prev; rustPlatform.buildRustPackage rec {
      name = "swhkd-${version}";
      version = "1.2.1";
      src = fetchgit {
        #owner = "waycrate";
        #repo = "swhkd";
        rev = "refs/tags/1.2.1";
        url = "https://github.com/waycrate/swhkd.git";
        sha256 = "";
      };
      #buildInputs = [ openssl pkgconfig sqlite ];

      checkPhase = "";
      cargoSha256 = "sha256:1bk7kr6i5xh7b45caf93i096cbblajrli0nixx9m76m3ya7vnbp5";

      #meta = with stdenv.lib; {
      #  description = "Minimal IRC URL bot in Rust";
      #  homepage = https://github.com/nuxeh/url-bot-rs;
      #  license = licenses.isc;
      #  #maintainers = [ maintainers.tailhook ];
      #  platforms = platforms.all;
      #};

    };

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
