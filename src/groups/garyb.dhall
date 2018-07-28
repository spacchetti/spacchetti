    let mkPackage = ./../mkPackage.dhall 

in  { debug =
        mkPackage
        [ "prelude" ]
        "https://github.com/garyb/purescript-debug.git"
        "v4.0.0"
    }
