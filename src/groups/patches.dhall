    let mkPackage = ./../mkPackage.dhall

in  { unordered-collections =
        mkPackage
        [ "prelude", "record", "tuples", "integers", "enums" ]
        "https://github.com/justinwoo/purescript-unordered-collections.git"
        "missing-deps"
    }
