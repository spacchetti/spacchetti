    let mkPackage = ./../mkPackage.dhall

in  { event =
        mkPackage
        [ "prelude"
        , "console"
        , "effect"
        , "filterable"
        , "nullable"
        , "unsafe-reference"
        , "js-timers"
        , "now"
        ]
        "https://github.com/paf31/purescript-event.git"
        "v1.2.4"
    }
