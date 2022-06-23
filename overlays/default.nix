inputs: final: prev:

rec {
  unstable = import inputs.nixpkgs-unstable {
    system = prev.system;
    config = {
      allowUnfree = final.config.allowUnfree;
      allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
        "write_stylus"
      ];
    };
  };

  nur = import inputs.nur {
    pkgs = prev;
    nurpkgs = prev;
    repoOverrides = {
      #paul = import paul { pkgs = prev; };
    };
  };

  nix = unstable.nix;
  #alacritty = unstable.alacritty;  # symlink autoreload on v0.10
  polybar = unstable.alacritty;  # colors = ~/.config/polybar/colors
  #lightdm = unstable.lightdm;  # TODO test if remembers username is solved (it does not :()

  neovim = (import ./neovim) final prev;
}
