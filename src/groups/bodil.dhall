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
    }
