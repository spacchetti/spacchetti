    let mkPackage = ./../mkPackage.dhall

in  { unordered-collections =
        mkPackage
        [ "prelude" ]
        "https://github.com/fehrenbach/purescript-unordered-collections.git"
        "v1.3.0"
    }
