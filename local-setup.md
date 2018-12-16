# Local Project Usage "Example"

If you really insist on having a local workflow where you only have overrides specific to your project, this is your solution.

## Packages.dhall

```hs
    let mkPackage =
          https://raw.githubusercontent.com/spacchetti/spacchetti/190618/src/mkPackage.dhall

in  let overrides =
          { typelevel-prelude =
              mkPackage
              [ "proxy", "prelude", "type-equality" ]
              "https://github.com/justinwoo/purescript-typelevel-prelude.git"
              "prim-boolean"
          }

in    https://raw.githubusercontent.com/spacchetti/spacchetti/190618/src/packages.dhall
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

Example: <https://github.com/justinwoo/hack-symbol-breakon/blob/28e3b2fc003c63d325d990686ae7220da42fe561/packages.dhall>

## insdhall.sh (+x)

```sh
NAME='local'
TARGET=.psc-package/$NAME/.set/packages.json
mkdir -p .psc-package/$NAME/.set
dhall-to-json --pretty <<< './packages.dhall' > $TARGET
echo wrote packages.json to $TARGET
```

Example: <https://github.com/justinwoo/hack-symbol-breakon/blob/28e3b2fc003c63d325d990686ae7220da42fe561/insdhall.sh>
