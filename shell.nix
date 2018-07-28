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
        doCheck = false;
      };
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

  overrideAttrs = attrs: f: attrs // f attrs;

  smallShellArgs = {
    buildInputs = [
      dhall
      dhall-json
      dhall-nix
      perl
      jq
      psc-package
      nix-prefetch-scripts
    ];
  };

  fullShellArgs = overrideAttrs smallShellArgs (old: {
    buildInputs = old.buildInputs ++ hDeps;
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
    inherit (h.libnix.env) shellHook;
  } // (if glibcLocales != null
    # TODO: remove once https://github.com/dhall-lang/dhall-haskell/issues/504 is fixed
    then { LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive"; }
    else {})
  );

in
mkShell (fullShellArgs // {
  passthru.small = mkShell smallShellArgs;
})

