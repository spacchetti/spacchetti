{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    dhall
    dhall-json
    perl
    jq
    psc-package
    # TODO: remove once https://github.com/dhall-lang/dhall-haskell/issues/504 is fixed
    glibcLocales
  ];
  # TODO: like glibc locales
  LC_ALL = "en_US.UTF-8";
}
