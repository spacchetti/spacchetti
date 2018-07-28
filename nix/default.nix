{ pkgs ? import <nixpkgs> {} }:

let
  dhallFiles = ../src;

  # convert dhall set to a nix file
  spacchettiNix = pkgs.runCommand "spacchetti.nix" {} ''
    ${pkgs.dhall-nix}/bin/dhall-to-nix \
      <<< "${dhallFiles}/packages.dhall" \
      > $out
  '';

  spacchettiJson = pkgs.runCommand "spacchetti.json" {} ''
    ${pkgs.dhall-json}/bin/dhall-to-json \
      <<< "${dhallFiles}/packages.dhall" \
      > $out
  '';

  # import said nix files
  spacchetti = import spacchettiNix;

  # make all references to `"dependency"` a reference to `self.dependency`
  # instead, where `self` is the version of the packageset with all dependencies
  # already resolving correctly.
  #
  # gitHashes: this is a temporary hack;
  # an attrset of all package’s git hashes as output by nix-prefetch-git,
  # indexed by package name.
  #
  # buildPackage: a function:
  #  { name: String
  #  , version: String
  #  , dependencies: List a
  #  , src: Drv }
  # -> a
  # if you insert Drv for a, you get out a set of derivations.
  # In FP-lingo, this is an algebra; the whole thing is a manual catamorphism.
  transformedSpacchetti = gitHashes: buildPackage: with pkgs.lib;
    fix (self:
      let depStringToSymbol = str:
            # nix allows you to reference attributes of an attrset by string name.
            # So we are able to map the strings to actual symbols.
            self.${str};
          pkgToDerivation = name: pkg: pkgs.fetchgit {
            url = pkg.repo;
            # TODO: hashes should exist in pkg already
            sha256 = gitHashes.${name};
          };
          convertPkg = name: pkg: buildPackage {
            inherit name;
            inherit (pkg) version;
            dependencies = map depStringToSymbol pkg.dependencies;
            src = pkgToDerivation name pkg;
          };
      in mapAttrs convertPkg spacchetti
    );

  # fetchHashes = pkg.writeScript "fetchHashes" ''
  #   #!{pkgs.bash}/bin/bash
  #   set -e
  #   tmp=$(mktemp -d)
  #   ${../scripts/get-git-sha.pl} ${spacchettiJson} \
  #     > ''${tmp}/hashes.json
  #   # TODO: from packages?
  #   nix-build -A

  buildPackage = {name, version, dependencies, src}: {
    inherit name version;
    drv = pkgs.linkFarm "${name}-${version}"
            ([ { name = "src"; path = src; } ]
              ++ (map ({name, version, drv}: {
                        name = "${name}-${version}";
                        path = drv;
                  })
                  dependencies));
  };

in transformedSpacchetti
     (builtins.fromJSON (builtins.readFile ../git-sha.json))
     buildPackage
