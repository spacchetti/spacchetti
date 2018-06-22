# Local Project Usage "Example"

You probably shouldn't do this.

## Packages.dhall

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

## Psc-Package.json

```json
{
  "name": "project",
  "set": "local",
  "source": "",
  "depends": ["prelude", "ytcasts"]
}
```

## insdhall.sh (+x)

```sh
NAME='local'
TARGET=.psc-package/$NAME/.set/packages.json
mkdir -p .psc-package/$NAME/.set
dhall-to-json --pretty <<< './packages.dhall' > $TARGET
echo wrote packages.json to $TARGET
```
