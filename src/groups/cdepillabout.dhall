    let mkPackage = ./../mkPackage.dhall

in  { email-validate =
        mkPackage
        [ "aff", "generics-rep", "string-parsers", "transformers" ]
        "https://github.com/cdepillabout/purescript-email-validate.git"
        "v3.0.1"
    }
