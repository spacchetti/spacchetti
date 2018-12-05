let mkPackage = ./../mkPackage.dhall

in  { mmorph =
        mkPackage
        [ "functors", "transformers", "free" ]
        "https://github.com/Thimoteus/purescript-mmorph.git"
        "v5.1.0"
    }
