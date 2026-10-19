final: prev:

prev.buildNpmPackage rec {
  pname = "colorthief-cli";
  version = "3.3.1";

  src = prev.fetchFromGitHub {
    owner = "lokesh";
    repo = "color-thief";
    rev = "v${version}";
    hash = "sha256-iG+Jca5mhM8Dn65L/N8BczYCt84SF2q/bKgOvOZ9mUQ=";
  };

  npmDepsHash = "sha256-c/0B1oKb35DRYLG1m+MRASibjoww5eo4bqVZu4DlzDU=";

  npmFlags = [
    "--ignore-scripts"
  ];

  CYPRESS_INSTALL_BINARY = "0";
  npm_config_ignore_scripts = "true";

  nativeBuildInputs = [
    prev.makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/colorthief-cli
    cp -r . $out/lib/colorthief-cli

    mkdir -p $out/bin

    makeWrapper ${prev.nodejs_22}/bin/node $out/bin/colorthief \
      --add-flags "$out/lib/colorthief-cli/dist/cli.js"

    runHook postInstall
  '';

  meta = with prev.lib; {
    description = "CLI for extracting dominant colors and palettes from images";
    homepage = "https://github.com/lokesh/color-thief";
    license = licenses.mit;
    mainProgram = "colorthief";
  };
}
