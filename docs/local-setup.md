# Project-Local setup

There's now a CLI for the repetitive boilerplate generation and task running parts here: <https://github.com/justinwoo/spacchetti-cli>

In psc-package, there is nothing like "extra-deps" from Stack. Even though editing a package set isn't hard, it can be fairly meaningless to have a package set that differs from package sets that you use for your other projects. While there's no real convenient way to work with it with standard purescript/package-sets, this is made easy with Dhall again where you can define a packages.dhall file in your repo and refer to remote sources for mkPackage and some existing packages.dhall.

## With the CLI

With the Spacchetti CLI, you can automate the manual setup below and run a single command to update your package set.

To use the CLI, you will first need fulfill the [requirements](working.html).

Then, install the Spacchetti CLI in a manner you prefer:

* npm: you can use `npm install --global spacchetti-cli-bin-simple` to install via npm.
* Github releases: You can go to the release page on Github, download the archive with your platform's binary, and put it somewhere on your PATH <https://github.com/justinwoo/spacchetti-cli/releases>
* stack install: You can clone the repository and run `stack install`: <https://github.com/justinwoo/spacchetti-cli>

When you have installed the CLI, you can run `spacchetti` to be shown the help message:

```
Spacchetti CLI

Usage: spacchetti (local-setup | insdhall)

Available options:
  -h,--help                Show this help text

Available commands:
  local-setup              run project-local Spacchetti setup
  insdhall                 insdhall the local package set
```

### Local setup

First, run the local-setup command to get the setup generated.

```
spacchetti local-setup
```

This will generate two files:

* `packages.dhall`: this is your local package set file, which will refer to the upstream package set and also assign a `upstream` variable you can use to modify your package set.
* `psc-package.json`: this is the normal psc-package file, with the change that it will refer to a "local" set.

Before you try to run anything else, make sure you run `spacchetti inshdall`:

### InsDhall

Now you can run the ins-dhall-ation of your package set:

```
spacchetti insdhall
```

This will generate the package set JSON file from your package set and place it in the correct path that psc-package will be able to use. You can now use `psc-package install` and other normal psc-package commands.

### Updating the local package set

For example, you may decide to use some different versions of packages defined in the package set. This can be achieved easily with record merge updates in Dhall:

```hs
    let mkPackage =
          https://raw.githubusercontent.com/justinwoo/spacchetti/140918/src/mkPackage.dhall

in  let upstream =
          https://raw.githubusercontent.com/justinwoo/spacchetti/140918/src/packages.dhall

in  let overrides =
          { halogen =
              upstream.halogen ⫽ { version = "master" }
          , halogen-vdom =
              upstream.halogen-vdom ⫽ { version = "v4.0.0" }
          }

in  upstream ⫽ overrides
```

If you have already fetched these packages, you will need to remove the `.psc-package/` directory, but you can otherwise proceed.

Run the ins-dhall-ation one more time:

```
spacchetti insdhall
```

Now you can install the various dependencies you need by running `psc-package install` again, and you will have a locally patched package set you can work with without upstreaming your changes to a package set.

You might still refer to the manual setup notes below to see how this works and how you might remove the Spacchetti CLI from your project workflow should you choose to.

### With CI

You can install everything you need on CI using some kind of setup like the following.

These examples come from vidtracker: <https://github.com/justinwoo/vidtracker/tree/37c511ed82f209e0236147399e8a91999aaf754c>

#### Azure

```yaml
pool:
  vmImage: 'Ubuntu 16.04'

steps:
- script: |
    DHALL=https://github.com/dhall-lang/dhall-haskell/releases/download/1.17.0/dhall-1.17.0-x86_64-linux.tar.bz2
    DHALL_JSON=https://github.com/dhall-lang/dhall-json/releases/download/1.2.3/dhall-json-1.2.3-x86_64-linux.tar.bz2

    wget -O $HOME/dhall.tar.gz $DHALL
    wget -O $HOME/dhall-json.tar.gz $DHALL_JSON

    tar -xvf $HOME/dhall.tar.gz -C $HOME/
    tar -xvf $HOME/dhall-json.tar.gz -C $HOME/

    chmod a+x $HOME/bin

    npm set prefix ~/.npm
    npm i -g purescript psc-package-bin-simple spacchetti-cli-bin-simple

  displayName: 'Install deps'
- script: |
    export PATH=~/.npm/bin:./bin:$HOME/bin:$PATH

    which spacchetti
    which dhall
    which dhall-to-json

    make
  displayName: 'Make'
```

#### Travis

```yaml
language: node_js
sudo: required
dist: trusty
node_js: stable
env:
  - PATH=./bin:$HOME/bin:$PATH
install:
  - DHALL=https://github.com/dhall-lang/dhall-haskell/releases/download/1.17.0/dhall-1.17.0-x86_64-linux.tar.bz2
  - DHALL_JSON=https://github.com/dhall-lang/dhall-json/releases/download/1.2.3/dhall-json-1.2.3-x86_64-linux.tar.bz2
  - SPACCHETTI=https://github.com/justinwoo/spacchetti-cli/releases/download/0.2.0.0/linux.tar.gz
  - wget -O $HOME/dhall.tar.gz $DHALL
  - wget -O $HOME/dhall-json.tar.gz $DHALL_JSON
  - wget -O $HOME/spacchetti.tar.gz $SPACCHETTI
  - tar -xvf $HOME/dhall.tar.gz -C $HOME/
  - tar -xvf $HOME/dhall-json.tar.gz -C $HOME/
  - tar -xvf $HOME/spacchetti.tar.gz -C $HOME/bin
  - chmod a+x $HOME/bin
  - npm install -g purescript pulp psc-package-bin-simple
script:
  - which dhall
  - which dhall-to-json
  - which spacchetti
  - make
```

## Manual setup

See the moved notes [here](local-setup-manual.html)
