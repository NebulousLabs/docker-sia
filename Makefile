name=sia-container
version=1.5.0

default: release

all: release dev alpine pi

dev:
	docker build -f dev/Dockerfile \
		-t $(name) -t nebulouslabs/sia:dev \
		.

release:
	docker build -f Dockerfile \
		--build-arg SIA_VERSION=$(version) \
		-t $(name) -t nebulouslabs/sia:$(version) -t nebulouslabs/sia:latest \
		.

alpine:
	docker build -f alpine/Dockerfile \
		--build-arg SIA_VERSION=$(version) \
		-t $(name) -t nebulouslabs/sia:alpine-$(version) -t nebulouslabs/sia:alpine-latest \
		.

pi:
	docker build -f pi/Dockerfile \
		--build-arg SIA_VERSION=$(version) \
		-t $(name) -t nebulouslabs/sia:pi-$(version) -t nebulouslabs/sia:pi-latest \
		.

stop:
	docker stop $(docker ps -a -q --filter "name=$(name)") && docker rm $(docker ps -a -q --filter "name=$(name)")

# TODO ssh, ps, run with custom sia-data and log dir

.PHONY: all default dev release alpine pi stop
