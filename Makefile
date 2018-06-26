all: format generate

format:
	./format.sh

generate:
	./generate.sh

setup: all
	./verify-setup.sh
