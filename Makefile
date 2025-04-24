# Makefile
include .env

init:
	git submodule update --init --recursive

test:
	forge test -vvv --fork-url $(RPC_URL)

coverage:
	forge coverage --report lcov

clean:
	forge clean

build:
	forge build

deploy:
	forge script script/Deploy.s.sol:Deploy --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify

.PHONY: test coverage clean build deploy