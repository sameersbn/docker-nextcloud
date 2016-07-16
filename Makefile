all: build

build:
	@docker build --tag=sameersbn/nextcloud .

release: build
	@docker build --tag=sameersbn/nextcloud:$(shell cat VERSION) .
