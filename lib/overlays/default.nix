# WARNING: not ready

inputs:

{
  unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.system;
      config.allowUnfree = true;
    };
  };
}

#inputs:
#let {
#};
#in final: prev: {
#};
