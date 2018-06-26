    let mkPackage = ./../mkPackage.dhall

in  { aff-promise =
        mkPackage
        [ "aff", "foreign" ]
        "https://github.com/nwolverson/purescript-aff-promise.git"
        "2.0.0"
    }
