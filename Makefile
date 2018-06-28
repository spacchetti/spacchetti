all: format generate validate

format:
	./format.sh

generate:
	./generate.sh

validate:
	./validate.pl

setup: all
	./setup.sh
