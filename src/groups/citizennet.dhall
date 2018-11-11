    let mkPackage = ./../mkPackage.dhall

in  { halogen-select =
        mkPackage
        [ "halogen", "halogen-renderless" ]
        "https://github.com/citizennet/purescript-halogen-select.git"
        "v3.0.1"
    }
