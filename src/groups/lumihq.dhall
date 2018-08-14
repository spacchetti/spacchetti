    let mkPackage = ./../mkPackage.dhall

in  { react-basic =
        mkPackage
        [ "effect"
        , "exceptions"
        , "functions"
        , "nullable"
        , "record"
        , "typelevel-prelude"
        , "unsafe-coerce"
        , "web-dom"
        , "web-events"
        ]
        "https://github.com/lumihq/purescript-react-basic.git"
        "v2.0.0"
    }
