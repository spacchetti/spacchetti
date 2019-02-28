let mkPackage = ./../mkPackage.dhall

in  { remotedata =
        mkPackage
        [ "either", "profunctor-lenses", "bifunctors", "generics-rep" ]
        "https://github.com/krisajenkins/purescript-remotedata.git"
        "v4.0.0"
    }
