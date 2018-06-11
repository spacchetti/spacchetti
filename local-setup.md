# Local Project Usage "Example"

You probably shouldn't do this.

## Packages.dhall

Replace the relative paths with some raw github link that points to a certain SHA

```hs
    let mkPackage = ./../package-sets-ex/src/mkPackage.dhall

in  let overrides =
          { something =
              mkPackage
              [ "aff"
              , "console"
              , "prelude"
              ]
              "https://github.com/someorg/purescript-something.git"
              "v0.0.0"
          }

in    ./../package-sets-ex/src/groups/purescript.dhall
    ⫽ ./../package-sets-ex/src/groups/purescript-contrib.dhall
    ⫽ ./../package-sets-ex/src/groups/purescript-web.dhall
    ⫽ ./../package-sets-ex/src/groups/purescript-node.dhall
    ⫽ ./../package-sets-ex/src/groups/slamdata.dhall
    ⫽ ./../package-sets-ex/src/groups/community.dhall
    ⫽ ./../package-sets-ex/src/groups/natefaubion.dhall
    ⫽ ./../package-sets-ex/src/groups/justinwoo.dhall
    ⫽ ./../package-sets-ex/src/groups/patches.dhall
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
