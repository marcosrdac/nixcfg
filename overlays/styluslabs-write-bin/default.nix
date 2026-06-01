final: prev:

with prev;

styluslabs-write-bin.overrideAttrs (
  old: rec {
    version = "-latest";
    src = fetchurl {
      url = "http://www.styluslabs.com/write/write${version}.tar.gz";
      sha256 = "sha256-NiBTrzjxRfpahUK3yBwUrltoiJMYZJMm+3fWgZNQTgo=";
    };
  }
)
