final: prev:

with prev;

write_stylus.overrideAttrs (
  old: rec {
    version = "-latest";
    src = fetchurl {
      url = "http://www.styluslabs.com/write/write${version}.tar.gz";
      sha256 = "sha256-1dy3r4akvehDybZ3ncC5k0BmZsL/K9EQYsdVMtPWocA=";
    };
  }
)
