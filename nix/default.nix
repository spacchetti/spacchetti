{ pkgs ? import ./nixpkgs.nix {} }:

with pkgs.lib;

let
  dhallFiles = ../src;

  # convert dhall packages set to a nix file
  spacchettiNix = pkgs.runCommand "spacchetti.nix" {} ''
    ${pkgs.dhall-nix}/bin/dhall-to-nix \
      <<< "${dhallFiles}/packages.dhall" \
      > $out
  '';

  # convert dhall package set to a json file
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
  transformedSpacchetti = gitHashes: buildPackage:
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

  buildPscPackageSet =
    let
      # Create a package set that can be used from psc-package
      # by linking it to `.psc-package/$name` in the project folder
      # and setting the `"set"` field in `psc-package.json` to $name.
      # TODO: use execline linkfarm
      pscPackageSet = srcDeps: pkgs.runCommand "spacchetti" {} ''
        # this is the package list psc-package references
        mkdir -p $out/.set
        ln -s '${spacchettiJson}' $out/.set/packages.json

        # now we link in all packages
        ${concatStringsSep "\n"
            ( # TODO: escaping?
              mapAttrsToList (name: {version, src}: ''
                mkdir -p "$out/${name}"
                ln -s '${src}' "$out/${name}/${version}"
              '') SrcDeps)}
      '';

      # `buildPackage` function that compiles a set of purescript pakages.
      # The result is a set of package names to
      # { src                # source code of the package
      # , compiled           # compiled output of the package
      # , transitiveSrc      # list of the sources
      #                      # of all transitive dependencies
      # , transitiveCompiled # list of the compiled outputs
      #                      # of all transitive dependencies
      # }
      compileAll = {name, version, src, dependencies}:
        let
          mergeByName = builtins.foldl' mergeAttrs {};
          # We (abuse?) the fact, that each packages has a unique name
          # to collect all transitive dependencies.
          transitiveSrc = mergeByName
            ([{ ${name} = src; }] ++ (map (d: d.transitiveSrc) dependencies));
          transitiveCompiled = mergeByName
            (map (d: d.transitiveCompiled) dependencies);

          compiled = pkgs.runCommand "${name}-${version}" {} ''
            mkdir $out
            # TODO: should be able to give these inputs to purs directly
            ${# this is the cache of all dependencies already compiled
              # so we don’t have to rebuild them
              concatStringsSep "\n"
               (mapAttrsToList (_: compiled: ''ln -s "${compiled}"/* $out'')
                 transitiveCompiled)}

            ${pkgs.purescript}/bin/purs compile \
              --output $out \
              ${# purs needs the source code of all transitive dependencies;
                # already includes our own
                concatStringsSep "\\\n  "
                  (mapAttrsToList (_: src: "'${src}/src/**/*.purs'")
                      transitiveSrc)}

            # TODO: hack to remove the other compiled modules again;
            # everything that is a symlink was added by us above
            for dir in $out/*; do
              test -L "$dir" && rm "$dir" || true
            done
          '';
        in {
          inherit src compiled transitiveSrc;
          transitiveCompiled = transitiveCompiled // { ${name} = compiled; };
        };

      # we use the fact that spacchetti must already list
      # all needed packages at the top level to link a flat
      # dependency structure.
      # ignoreDeps = pkg: removeAttrs pkg [ "name" "dependencies" ];

      packages =
        transformedSpacchetti
          # TODO: pass sha.json explicitely
          (builtins.fromJSON (builtins.readFile ../git-sha.json))
          # ignoreDeps;
          compileAll;

    # in linkDeps packages;
    in mapAttrs (_: p: p.compiled) packages;


in buildPscPackageSet
