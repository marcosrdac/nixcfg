inputs: final: prev:

rec {
  unstable = import inputs.nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = true;
    };
  };

  nur = import inputs.nur {
    pkgs = prev;
    nurpkgs = prev;
    repoOverrides = {
      #paul = import paul { pkgs = prev; };
    };
  };

  neovim = (import ./neovim) final prev;

  alacritty = unstable.alacritty;  # symlink autoreload on v0.10

}


# let
#   importChildren = (
#     dir: map (mod: import (dir + "/${mod}"))
#       (builtins.attrNames (builtins.readDir dir))
#   );

