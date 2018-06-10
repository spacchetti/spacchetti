    let mkPackage = ./../mkPackage.dhall 

in  { aff-promise =
        mkPackage
        [ "aff", "foreign" ]
        "https://github.com/nwolverson/purescript-aff-promise.git"
        "v2.0.0"
    , ansi =
        mkPackage
        [ "foldable-traversable", "lists", "strings" ]
        "https://github.com/hdgarrood/purescript-ansi"
        "v5.0.0"
    , colors =
        mkPackage
        [ "arrays", "integers", "lists", "partial", "strings" ]
        "https://github.com/sharkdp/purescript-colors.git"
        "v5.0.0"
    , debug =
        mkPackage
        [ "prelude" ]
        "https://github.com/garyb/purescript-debug.git"
        "v4.0.0"
    , filterable =
        mkPackage
        [ "arrays"
        , "assert"
        , "console"
        , "either"
        , "foldable-traversable"
        , "lists"
        , "ordered-collections"
        ]
        "https://github.com/LiamGoodacre/purescript-filterable.git"
        "v3.0.0"
    , freeap =
        mkPackage
        [ "const", "exists", "gen", "lists" ]
        "https://github.com/ethul/purescript-freeap.git"
        "v5.0.0"
    , group =
        mkPackage
        [ "lists", "psci-support" ]
        "https://github.com/morganthomas/purescript-group"
        "v3.3.0"
    , mmorph =
        mkPackage
        [ "functors", "transformers" ]
        "https://github.com/Thimoteus/purescript-mmorph.git"
        "v5.0.0"
    , numbers =
        mkPackage
        [ "globals", "math", "maybe" ]
        "https://github.com/sharkdp/purescript-numbers.git"
        "v6.0.0"
    , pipes =
        mkPackage
        [ "aff"
        , "lists"
        , "mmorph"
        , "prelude"
        , "tailrec"
        , "transformers"
        , "tuples"
        ]
        "https://github.com/felixSchl/purescript-pipes.git"
        "v6.0.0"
    , prettier =
        mkPackage
        [ "maybe", "prelude" ]
        "https://github.com/gcanti/purescript-prettier.git"
        "v0.2.0"
    , record-format =
        mkPackage
        [ "record", "strings", "typelevel-prelude" ]
        "https://github.com/kcsongor/purescript-record-format.git"
        "v0.1.0"
    , spec =
        mkPackage
        [ "aff"
        , "ansi"
        , "console"
        , "exceptions"
        , "foldable-traversable"
        , "generics-rep"
        , "pipes"
        , "prelude"
        , "strings"
        , "transformers"
        ]
        "https://github.com/owickstrom/purescript-spec.git"
        "v3.0.0"
    , test-unit =
        mkPackage
        [ "aff"
        , "avar"
        , "effect"
        , "either"
        , "free"
        , "js-timers"
        , "lists"
        , "prelude"
        , "quickcheck"
        , "strings"
        ]
        "https://github.com/bodil/purescript-test-unit.git"
        "v14.0.0"
    , unordered-collections =
        mkPackage
        [ "enums"
        , "foldable-traversable"
        , "integers"
        , "maybe"
        , "prelude"
        , "record"
        , "tuples"
        ]
        "https://github.com/fehrenbach/purescript-unordered-collections.git"
        "v1.0.1"
    }
