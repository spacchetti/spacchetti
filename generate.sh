dhall-to-json --pretty <<< "./src/packages.dhall" > packages.json
psc-package format
echo generated to packages.json
