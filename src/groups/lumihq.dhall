    let mkPackage = ./../mkPackage.dhall

in  { react-basic =
        mkPackage
        [ "effect"
        , "functions"
        , "nullable"
        , "record"
        , "typelevel-prelude"
        , "unsafe-coerce"
        ]
        "https://github.com/lumihq/purescript-react-basic.git"
        "v1.0.0"
    }
