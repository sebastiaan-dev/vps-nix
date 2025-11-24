{ pkgs, ... }:
let
  pyPkgs = pkgs.python312Packages;
in
{
  languages.python = {
    enable = true;
    package = pkgs.python312;
    venv.enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
  };

  packages = [
    pyPkgs.numpy
    pyPkgs.pandas
    pyPkgs.matplotlib
    pyPkgs.requests
    pyPkgs.ipython
    pyPkgs.pytest
    pyPkgs.black
    pyPkgs.mypy
  ];

  scripts = {
    test.exec = "pytest";
    fmt.exec = "black .";
    typecheck.exec = "mypy .";
  };
}
