let
  commit = "b8561e3e20750043f238d88cc5b321f181f9d11f";
  sha256 = "1kp8ks4jfaa2rzdbwfy8y4imvgrcb1hby7qh5vhapjxh562h9shr";

in import (builtins.fetchTarball {
  # nixpkgs unstable 2018-05-31
  url = "https://github.com/NixOS/nixpkgs/archive/${commit}";
  inherit sha256;
})
