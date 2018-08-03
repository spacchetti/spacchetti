    let mkPackage = ./../mkPackage.dhall

in  { halogen-select =
        mkPackage
        [ "halogen" ]
        "https://github.com/citizennet/purescript-halogen-select.git"
        "v2.0.0"
    }
