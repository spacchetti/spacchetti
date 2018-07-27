    let mkPackage = ./../mkPackage.dhall

in  { email-validate =
        mkPackage
        [ "aff", "generics-rep", "string-parsers", "transformers" ]
        "https://github.com/justinwoo/purescript-email-validate.git"
        "update-string-parsers-5.0"
    }
