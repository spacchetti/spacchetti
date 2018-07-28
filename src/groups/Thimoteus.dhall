    let mkPackage = ./../mkPackage.dhall 

in  { mmorph =
        mkPackage
        [ "functors", "transformers" ]
        "https://github.com/Thimoteus/purescript-mmorph.git"
        "v5.0.0"
    }
