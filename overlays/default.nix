{ inputs }:

final: prev: {
  nix = final.unstable.nix;

  # outer overlays
  polybar = final.unstable.polybar;  # colors = ~/.config/polybar/colors
  transmission = final.unstable.transmission;

  colorthief = import ./colorthief final prev;
  #material-theme-image = import ./material-theme-image final prev;
  color-extract = import ./color-extract final prev;

  quarto = import ./quarto final prev.nixpkgs-25-05;  # while a new version does not work for pdf (1.9.37)

  # inner overlays
  opencode-v2 = prev.stdenv.mkDerivation rec {
    pname = "opencode-v2";
    version = "2.0.28";

    src = prev.fetchurl {
      url = "https://registry.npmjs.org/@opencode%2fcli-linux-x64/-/cli-linux-x64-${version}.tgz";
      hash = "sha256-dvhQW6r1aWXtKPMFt0xSa1TszRj+eMgWIaQJDMAmyfk=";
    };

    sourceRoot = "package";

    nativeBuildInputs = [ prev.autoPatchelfHook prev.makeBinaryWrapper ];
    buildInputs = [ prev.stdenv.cc.cc.lib ];
    # Bun single-file executables append the application payload to the ELF.
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 bin/opencode $out/bin/opencode
      runHook postInstall
    '';

    postInstall = ''
      wrapProgram $out/bin/opencode \
        --prefix PATH : ${prev.lib.makeBinPath [ prev.ripgrep ]} \
        --set OPENCODE_DISABLE_AUTOUPDATE true
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      export HOME=$(mktemp -d)
      test "$($out/bin/opencode --version)" = "opencode v${version}"
      runHook postInstallCheck
    '';

    meta = {
      description = "AI coding agent built for the terminal (V2)";
      homepage = "https://opencode.ai/";
      license = prev.lib.licenses.mit;
      mainProgram = "opencode";
      platforms = [ "x86_64-linux" ];
    };
  };
  neovim = import ./neovim final prev;
  styluslabs-write-bin = import ./styluslabs-write-bin final prev;
  #networkmanager-vpnc = import ./networkmanager/plugins/vtnc final prev;
  #networkmanager-pptp = import ./networkmanager/plugins/pptp final prev;

  discord = prev.discord.overrideAttrs (_: { src = builtins.fetchTarball {
    url = "https://discord.com/api/download/stable?platform=linux&format=tar.gz";
    sha256 = "sha256:09rqqs8jgr8c1sh7kiypzy0vz8kyw776zcql09rf14m3frzza1di";};
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
