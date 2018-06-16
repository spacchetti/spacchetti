    let mkPackage = ./../mkPackage.dhall

in  { string-parsers =
        mkPackage
        [ "arrays"
        , "bifunctors"
        , "control"
        , "either"
        , "foldable-traversable"
        , "lists"
        , "maybe"
        , "prelude"
        , "strings"
        , "tailrec"
        ]
        "https://github.com/justinwoo/purescript-string-parsers.git"
        "no-code-points"
    , behaviors =
        mkPackage
        [ "prelude", "effect", "ordered-collections", "filterable", "nullable" ]
        "https://github.com/justinwoo/purescript-behaviors.git"
        "compiler/0.12"
    , choco-pie =
        mkPackage
        [ "prelude", "behaviors", "typelevel-prelude", "record" ]
        "https://github.com/justinwoo/purescript-choco-pie.git"
        "compiler/0.12"
    }
