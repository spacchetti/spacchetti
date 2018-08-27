    let mkPackage = ./../mkPackage.dhall

in  { variant =
        mkPackage
        [ "enums"
        , "lists"
        , "maybe"
        , "partial"
        , "prelude"
        , "record"
        , "tuples"
        , "typelevel-prelude"
        , "unsafe-coerce"
        ]
        "https://github.com/natefaubion/purescript-variant.git"
        "v5.1.0"
    , run =
        mkPackage
        [ "aff"
        , "effect"
        , "either"
        , "free"
        , "maybe"
        , "newtype"
        , "prelude"
        , "profunctor"
        , "tailrec"
        , "tuples"
        , "type-equality"
        , "unsafe-coerce"
        , "variant"
        ]
        "https://github.com/natefaubion/purescript-run.git"
        "v2.0.0"
    }
