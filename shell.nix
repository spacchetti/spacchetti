{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    dhall
    dhall-json
    perl
    jq
  ];
}
