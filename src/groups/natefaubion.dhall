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
        "v5.0.0"
    }
