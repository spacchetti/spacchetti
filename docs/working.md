# How to use this package set

## Requirements

This project requires that you have at least:

* Linux/OSX. I do not support Windows. You will probably be able to do everything using WSL, but I will not support any issues (you will probably barely run into any with WSL). I also assume your distro is from the last decade, any distributions older than 2008 are not supported.
* [Dhall-Haskell](https://github.com/dhall-lang/dhall-haskell) and [Dhall-JSON](https://github.com/dhall-lang/dhall-json) installed. You can probably install them from Nix or from source.
* [Psc-Package](https://github.com/purescript/psc-package/) installed, with the release binary in your PATH in some way.
* [jq](https://github.com/stedolan/jq) installed.

## How to generate the package set after editing Dhall files

First, test that you can actually run `make`:

```sh
> make
./format.sh
formatted dhall files
./generate.sh
generated to packages.json
./validate.pl
validated packages' dependencies
```

This is how you format Dhall files in the project, generate the `packages.json` that needs to be checked in, and validate that all dependencies declared in package definitions are at least valid. Unless you plan to consume only the `packages.dhall` file in your repository, you must check in `packages.json`.

To actually use your new package set, you must create a new git tag and push it to your **fork of spacchetti**. Then set your package set in your **project** repository accordingly, per EXAMPLE:

```js
{
  "name": "EXAMPLE",
  "set": "160618", // GIT TAG NAME
  "source": "https://github.com/justinwoo/spacchetti.git", // PACKAGE SET REPO URL
  "depends": [
    "console",
    "prelude"
  ]
}
```

When you set this up correctly, you will see that running `psc-package install` will create the file `.psc-package/{GIT TAG NAME HERE}/.set/packages.json`.

## Testing changes to package set

To set up a test project, run `make setup`. Then you can test individual packages with `psc-package verify PACKAGE`.

## Using Perl scripts in this repository

You will only need the following scripts:

* `verify.pl` - to install a given package and validate the entire compiled output.

* `add-from-bower.pl` - to add a package that is registered on Bower.

* `update-from-bower.pl` - to update a package that is registered on Bower.

These each take an argument of a package, e.g. `./update-from-bower.pl behaviors`.
