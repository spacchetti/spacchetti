let
  pkgs = import <nixpkgs> {};

  easy-ps = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "ccf766823f3d432072afc456fe795f67712a1f56";
    sha256 = "0a9wpyd1i48k1q7qfv3siazqx8kgpzl6d0ilb6lbdq9vkdixfx59";
  });
in pkgs.stdenv.mkDerivation {
  name = "easy-purescript";
  src = ./.;

  buildInputs = easy-ps.buildInputs;
}
