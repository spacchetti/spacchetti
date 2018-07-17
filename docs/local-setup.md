# Project-Local setup

In psc-package, there is nothing like "extra-deps" from Stack. Even though editing a package set isn't hard, it can be fairly meaningless to have a package set that differs from package sets that you use for your other projects. While there's no real convenient way to work with it with standard purescript/package-sets, this is made easy with Dhall again where you can define a packages.dhall file in your repo and refer to remote sources for mkPackage and some existing packages.dhall.

## `packages.dhall`

For example, we could patch `typelevel-prelude` locally in such a way in a project-local `packages.dhall` file:

```hs
    let mkPackage =
          https://raw.githubusercontent.com/justinwoo/spacchetti/190618/src/mkPackage.dhall

in  let overrides =
          { typelevel-prelude =
              mkPackage
              [ "proxy", "prelude", "type-equality" ]
              "https://github.com/justinwoo/purescript-typelevel-prelude.git"
              "prim-boolean"
          }

in    https://raw.githubusercontent.com/justinwoo/spacchetti/190618/src/packages.dhall
    ⫽ overrides
```

## `psc-package.json`

Then we need a `psc-package.json` file, but we will stub the package set information:

```json
{
  "name": "my-project",
  "set": "local",
  "source": "",
  "depends": [
    "console",
    "effect",
    "prelude",
    "typelevel-prelude"
  ]
}
```

## `insdhall.sh`

Finally, we will need to create the Psc-Package files and insert our local generated package set:

```sh
NAME='local'
TARGET=.psc-package/$NAME/.set/packages.json
mkdir -p .psc-package/$NAME/.set
dhall-to-json --pretty <<< './packages.dhall' > $TARGET
echo wrote packages.json to $TARGET
```

Once we run this script, we will now be able to use `psc-package install` and get to work.
