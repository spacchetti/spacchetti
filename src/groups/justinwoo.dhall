    let mkPackage = ./../mkPackage.dhall

in  { chanpon =
        mkPackage
        [ "effect", "node-sqlite3", "prelude", "record" ]
        "https://github.com/justinwoo/purescript-chanpon.git"
        "v1.0.0"
    , gomtang-basic =
        mkPackage
        [ "console", "effect", "prelude", "record", "web-html" ]
        "https://github.com/justinwoo/purescript-gomtang-basic.git"
        "v0.2.0"
    , jajanmen =
        mkPackage
        [ "node-sqlite3", "prelude", "typelevel-prelude" ]
        "https://github.com/justinwoo/purescript-jajanmen.git"
        "v0.1.0"
    , lenient-html-parser =
        mkPackage
        [ "console", "generics-rep", "prelude", "string-parsers" ]
        "https://github.com/justinwoo/purescript-lenient-html-parser.git"
        "v3.0.1"
    , makkori =
        mkPackage
        [ "functions", "node-http", "prelude", "record" ]
        "https://github.com/justinwoo/purescript-makkori.git"
        "v1.0.0"
    , milkis =
        mkPackage
        [ "aff-promise", "foreign-object", "prelude", "typelevel-prelude" ]
        "https://github.com/justinwoo/purescript-milkis.git"
        "v6.0.0"
    , node-he =
        mkPackage
        ([] : List Text)
        "https://github.com/justinwoo/purescript-node-he.git"
        "v0.2.0"
    , node-postgres =
        mkPackage
        [ "aff"
        , "arrays"
        , "datetime"
        , "either"
        , "foldable-traversable"
        , "foreign"
        , "integers"
        , "nullable"
        , "prelude"
        , "transformers"
        , "unsafe-coerce"
        ]
        "https://github.com/justinwoo/purescript-node-postgres.git"
        "0.12"
    , node-sqlite3 =
        mkPackage
        [ "aff", "foreign" ]
        "https://github.com/justinwoo/purescript-node-sqlite3"
        "v3.1.0"
    , record-extra =
        mkPackage
        [ "lists", "record", "typelevel-prelude" ]
        "https://github.com/justinwoo/purescript-record-extra.git"
        "v1.0.0"
    , shoronpo =
        mkPackage
        [ "prelude", "record-format" ]
        "https://github.com/justinwoo/purescript-shoronpo.git"
        "v0.3.0"
    , simple-json =
        mkPackage
        [ "exceptions"
        , "foreign"
        , "foreign-object"
        , "globals"
        , "nullable"
        , "prelude"
        , "record"
        , "typelevel-prelude"
        , "variant"
        ]
        "https://github.com/justinwoo/purescript-simple-json.git"
        "v4.0.0"
    , sunde =
        mkPackage
        [ "aff", "effect", "node-child-process", "prelude" ]
        "https://github.com/justinwoo/purescript-sunde.git"
        "v1.0.0"
    , toppokki =
        mkPackage
        [ "aff-promise"
        , "functions"
        , "node-buffer"
        , "node-http"
        , "prelude"
        , "record"
        ]
        "https://github.com/justinwoo/purescript-toppokki.git"
        "v1.0.0"
    , tortellini =
        mkPackage
        [ "foreign-object"
        , "integers"
        , "lists"
        , "numbers"
        , "prelude"
        , "record"
        , "string-parsers"
        , "strings"
        , "transformers"
        , "typelevel-prelude"
        ]
        "https://github.com/justinwoo/purescript-tortellini.git"
        "v2.0.1"
    , node-telegram-bot-api =
        mkPackage
        [ "strings", "foreign", "aff", "simple-json" ]
        "https://github.com/justinwoo/purescript-node-telegram-bot-api.git"
        "v4.0.0"
    }
