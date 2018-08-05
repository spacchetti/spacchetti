all: format generate validate

format:
	@ls src/**/*.dhall | xargs -I{} dhall format --inplace {}
	@echo formatted dhall files

generate:
	@dhall-to-json --pretty <<< "./src/packages.dhall" > packages.json
	@psc-package format
	@echo generated to packages.json

validate:
	@./scripts/validate.pl

setup: all setup-only

setup-only:
	@echo '{ "name": "test-package", "set": "testing", "source": "", "depends": [] }' > psc-package.json
	@mkdir -p .psc-package/testing/.set
	@cp packages.json .psc-package/testing/.set/packages.json
	@echo setup testing package set
