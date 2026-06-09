final: prev:

with prev;

nix-colors.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace lib/contrib/gtk-theme.nix \
        --replace "nodePackages.sass" "sassc"
    '';
  })
