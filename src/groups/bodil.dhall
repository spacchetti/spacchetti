    let mkPackage = ./../mkPackage.dhall

in  { test-unit =
        mkPackage
        [ "aff"
        , "avar"
        , "effect"
        , "either"
        , "free"
        , "js-timers"
        , "lists"
        , "prelude"
        , "quickcheck"
        , "strings"
        ]
        "https://github.com/bodil/purescript-test-unit.git"
        "v14.0.0"
    , typelevel =
        mkPackage
        [ "partial", "prelude", "tuples", "typelevel-prelude" ]
        "https://github.com/bodil/purescript-typelevel.git"
        "v4.0.0"
    }
