let
  pkgs = import <nixpkgs> {};

  easyPS = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "8d02bf2ce370a4f9a6997094b8eaa0a808372679";
    sha256 = "0b8da75vg9fgaga4v236ibycqski4138s35l35fciz3ydmzbf8hf";
  });
in {
  shell = pkgs.stdenv.mkDerivation {
    name = "easy-purescript-nix";
    src = ./.;

    buildInputs = [
      easyPS.purs
      easyPS.psc-package-simple
      easyPS.purp

      easyPS.dhall-simple
      easyPS.dhall-json-simple
      easyPS.spacchetti-cli
    ];
  };
}
