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
    , yargs =
        mkPackage
        [ "console", "either", "exceptions", "foreign", "unsafe-coerce" ]
        "https://github.com/paf31/purescript-yargs.git"
        "v4.0.0"
    , behaviors =
        mkPackage
        [ "effect"
        , "event"
        , "filterable"
        , "nullable"
        , "ordered-collections"
        , "prelude"
        , "web-events"
        , "web-html"
        , "web-uievents"
        ]
        "https://github.com/paf31/purescript-behaviors.git"
        "v7.0.0"
    , foreign-generic =
        mkPackage
        [ "effect"
        , "exceptions"
        , "foreign"
        , "foreign-object"
        , "generics-rep"
        , "ordered-collections"
        , "proxy"
        , "record"
        ]
        "https://github.com/paf31/purescript-foreign-generic.git"
        "v7.0.0"
    }
