all: format generate

format:
	./format.sh

generate:
	./generate.sh

setup:
	./verify-setup.sh
