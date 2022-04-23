inputs: final: prev:

with inputs;
{
  unstable = import nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "xpdf-4.03"
      ];
    };
  };

  nur = import nur {
    pkgs = prev;
    nurpkgs = prev;
    repoOverrides = {
      #paul = import paul { pkgs = prev; };
    };
  };

  neovim = (import ./neovim) final prev;
}


# let
#   importChildren = (
#     dir: map (mod: import (dir + "/${mod}"))
#       (builtins.attrNames (builtins.readDir dir))
#   );

