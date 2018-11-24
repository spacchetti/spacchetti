let
  pkgs = import <nixpkgs> {};

  easy-ps = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "68f64fb892f61a6e859a256b45f67ccb03694e26";
    sha256 = "15hkiz725lgzxg68h1r8gv03p6zm1nzwq40phaszryy28h6bifs5";
  });
in pkgs.stdenv.mkDerivation {
  name = "easy-ps-test";
  src = ./.;

  buildInputs = easy-ps.buildInputs;
}
