poetry    = $(shell command -v poetry)
dpkg      = $(shell command -v dpkg-buildpackage)
container = $(shell command -v podman)

PWD        := $(shell pwd)
IMAGE_NAME := python3-libspot-debian:11

.PHONY: package debian

build:
	@echo "Nothing to do..."

package:
	$(poetry) build

debian-image:
	$(container) build -t $(IMAGE_NAME) .

debian-container: debian-image
	$(container) run --rm -v $(PWD):/python3-libspot -w /python3-libspot $(IMAGE_NAME) /bin/bash -c 'make debian && cp ../python3-libspot*.deb dist/'

debian:
	$(dpkg) -us -uc -d