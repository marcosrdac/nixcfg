final: prev:

#prev.quarto.overrideAttrs (oldAttrs: {
  prev.quarto.overrideAttrs (oldAttrs: {
  postPatch = (oldAttrs.postPatch or "") + ''
    if grep -q "syntax-highlighting" bin/quarto.js; then
      substituteInPlace bin/quarto.js \
        --replace-fail "syntax-highlighting" "highlight-style"
    fi
  '';
})
