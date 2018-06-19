    let mkPackage = ./../mkPackage.dhall

in  { event =
        mkPackage
        [ "prelude", "console", "effect", "filterable", "nullable" ]
        "https://github.com/paf31/purescript-event.git"
        "v1.0.0"
    }
