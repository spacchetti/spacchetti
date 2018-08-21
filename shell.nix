{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  h = haskellPackages.override {
    overrides = self: super: {
      # libnix pinning
      libnix = super.mkDerivation {
        pname = "libnix";
        version = "0.3.0";
        src = fetchFromGitHub {
          owner = "Profpatsch";
          repo = "libnix-haskell";
          rev = "b891f4f425da5fa3e7e06bce98c56cf6cb6c876c";
          sha256 = "00wbz83mlgqq5ml7ysdw6wfr74grpac7sj3v9cylvhy2blx922yp";
        };
        license = lib.licenses.gpl3;
        buildDepends = with self; [ protolude aeson errors tasty-hunit ];
        # buildTools = [ nix ];
        doCheck = false;
      };
      # package for creating a shell with all tools
      # spacchetti-tools =
      #   let packages = with self; [ libnix dhall ];
      #   in super.mkDerivation {
      #     pname = "spacchetti-tools";
      #     version = "none";
      #     license = "none";
      #     buildDepends = packages;
      #     buildTools = with self;
      #       [ cabal-install (hoogleLocal { inherit packages; }) ];
      #   };
    };
  };

  hDeps = with h; [
    libnix
    dhall
    aeson-pretty
    either
    async-pool
    insert-ordered-containers
    retry
  ];
in
mkShell {
  buildInputs = [
    dhall
    dhall-json
    perl
    jq
    psc-package
  ] ++ hDeps;
  nativeBuildInputs = [
    h.cabal-install
    (h.hoogleLocal { packages = hDeps; })
    (h.ghcWithPackages (lib.const hDeps))
    nix-prefetch-scripts
  ];

  # for ghc
  # we copy a lot of stuff of the haskellPackages env builder,
  # because it is unfortunately not very composable.
  LANG = "en_US.UTF-8";
  # TODO: remove once https://github.com/dhall-lang/dhall-haskell/issues/504 is fixed
  LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  inherit (h.libnix.env) shellHook;
}

