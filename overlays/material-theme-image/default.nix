final: prev:

prev.buildNpmPackage {
  pname = "material-theme-image";
  version = "0.1.0";

  src = ./.;

  npmDepsHash = "sha256-HDP/+J3BfS5rgDvlY44a4t2LJ0OnDI547Hq0E3QrJ8c=";

  dontNpmBuild = true;

  nativeBuildInputs = [
    prev.makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/material-theme-image
    cp -r . $out/lib/material-theme-image

    mkdir -p $out/bin
    makeWrapper ${prev.nodejs_22}/bin/node $out/bin/material-theme-image \
      --add-flags "$out/lib/material-theme-image/material-theme-image.mjs"

    runHook postInstall
  '';

  meta = with prev.lib; {
    description = "Generate Material color roles from an image using Material Color Utilities";
    homepage = "https://github.com/material-foundation/material-color-utilities";
    license = licenses.asl20;
    mainProgram = "material-theme-image";
  };
}
