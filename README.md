# Spacchetti

[![Build Status](https://travis-ci.org/justinwoo/spacchetti.svg?branch=master)](https://travis-ci.org/justinwoo/spacchetti)

[![Documentation Status](https://readthedocs.org/projects/spacchetti/badge/?version=latest)](https://spacchetti.readthedocs.io/en/latest/?badge=latest)

*Mà, ho comprato una scatola di PureScript!*

![](https://i.imgur.com/roCuNQ9.png)

Dhall-driven package sets, made for forking and modifying easily. Per chi non ha paura di rimboccarsi le maniche (e arrotolare gli spaghetti).

Read the guide for more details on RTD: <https://spacchetti.readthedocs.io/en/latest/>

Read more about how this works here: <https://github.com/justinwoo/my-blog-posts#managing-psc-package-sets-with-dhall>

## The Raisin Deets

Nobody likes editing JSON. Even fewer actually like figuring out how to resolve conflicts in Git, especially if they aren't used to aborting rebases and digging up commits from reflog. Everyone complains there is no good solution for having your own patches on top of upstream changes, for when you want to add just a few of your own packages or override existing definitions.

Well, now all you have to do is complain that this repo doesn't have enough contributors, commits, maintenance, curation, etc., because those above issues are solved with the usage of Dhall to merge package definitions and Psc-Package verify on CI.

## How to use this package set

This project requires that you have at least:

* Linux/OSX. I do not support Windows. You will probably be able to do everything using WSL, but I will not support any issues (you will probably barely run into any with WSL). I also assume your distro is from the last decade, any distributions older than 2008 are not supported.
* [Dhall-Haskell](https://github.com/dhall-lang/dhall-haskell) and [Dhall-JSON](https://github.com/dhall-lang/dhall-json) installed. You can probably install them from Nix or from source.
* [Psc-Package](https://github.com/purescript/psc-package/) installed, with the release binary in your PATH in some way.
* [jq](https://github.com/stedolan/jq) installed.

If you use the [nix package manager](https://nixos.org/nix) you can open a shell with all dependencies by using the provided `shell.nix` file:

```
nix-shell --pure shell.nix
```

There is also a more minimal shell without the Haskell script dependencies available:

```
nix-shell --pure -A small shell.nix
```

### How files are organized

```hs
-- Package type definition
src/Package.dhall

-- function to define packages
src/mkPackage.dhall

-- packages to be included when building package set
src/packages.dhall

-- package "groups" where packages are defined in records
src/groups/[...].dhall
```

### How to generate the package set after editing Dhall files

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

### Testing changes to package set

To set up a test project, run `make setup`. Then you can test individual packages with `psc-package verify PACKAGE`.

### Using Perl scripts in this repository

You will only need the following scripts:

* `verify.pl` - to install a given package and validate the entire compiled output.

* `add-from-bower.pl` - to add a package that is registered on Bower.

* `update-from-bower.pl` - to update a package that is registered on Bower.

These each take an argument of a package, e.g. `./update-from-bower.pl behaviors`.

### Using Haskell scripts in this repository

```
$ nix-shell --pure --run "runhaskell scripts/Prefetch.hs" \
    | tee hashes.json
```

Outputs a record of all package’s git repository hashsums, by calling the nix prefetch scripts. Useful for consecutive building of Purescript packages with nix.

## Further Complaints

PRs welcome.

## FAQ

### Can I just consume this package set?

Yes, but do not expect me to add all of your packages for you. You should see [my post](https://github.com/justinwoo/my-blog-posts#managing-psc-package-sets-with-dhall) about this project or consult the ["local project usage example"](./local-setup.md).

### Don't you maintain purescript/package-sets?

Yes.

### Why should I use this "unofficial" package set?

If you think "official" is a thing, then you shouldn't.

### Can I get additional help?

Probably. Message me in some way (e.g. Twitter, FP Slack, or open an issue) and let's see what the nature of the issue is. If you need a lot of help, you can hire me part time.
