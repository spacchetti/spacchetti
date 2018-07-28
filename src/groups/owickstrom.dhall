    let mkPackage = ./../mkPackage.dhall 

in  { spec =
        mkPackage
        [ "aff"
        , "ansi"
        , "console"
        , "exceptions"
        , "foldable-traversable"
        , "generics-rep"
        , "pipes"
        , "prelude"
        , "strings"
        , "transformers"
        ]
        "https://github.com/owickstrom/purescript-spec.git"
        "v3.0.0"
    , spec-quickcheck =
        mkPackage
        [ "aff", "prelude", "quickcheck", "random", "spec" ]
        "https://github.com/owickstrom/purescript-spec-quickcheck.git"
        "v3.0.0"
    }
