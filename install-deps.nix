let
  pkgs = import <nixpkgs> {};
  packages = import ./packages.nix {};
  packageDrvs = builtins.attrValues packages.inputs;
  pp2n-utils = import (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/justinwoo/psc-package2nix/409aab26afa0784eb90440da33b1ad4d56aedb93/utils.nix";
    sha256 = "0rkqisfvpz5x8j2p0llv0yzgz5vnzy7fcfalp8nkymbshk8702gg";
  });

in pkgs.stdenv.mkDerivation {
  name = "install-deps";

  buildInputs = packageDrvs;

  shellHook = pp2n-utils.mkDefaultShellHook packages packageDrvs;
}
