final: prev:

prev.python3Packages.buildPythonApplication rec {
  pname = "color-extract";
  version = "0.0.5";
  pyproject = true;

  src = prev.fetchFromGitHub {
    owner = "brunoimbrizi";
    repo = "color-extract";
    rev = "v${version}";
    hash = "sha256-26GxmN09F7KtwTfOrQ9K+/SH4/hZdwvjEet/5aVuUrE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools>=61.0,<70.0.0",' ""
  '';

  build-system = with prev.python3Packages; [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = with prev.python3Packages; [
    pillow
    numpy
    scikit-learn
    scikit-image
    scipy
    click
    rich
  ];

  doCheck = false;
}
