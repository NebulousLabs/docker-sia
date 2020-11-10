name=sia-container
version=1.5.3

default: release

all: release alpine pi dev

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

dev:
	docker build -f dev/Dockerfile \
		--build-arg "SHA=$(sha)" \
		--build-arg "TAG=$(tag)" \
		-t $(name) -t nebulouslabs/sia:dev \
		.

debug:
	docker build -f debug/Dockerfile -t $(name) -t nebulouslabs/sia:debug .

ci:
	docker build -f ci/Dockerfile -t $(name) -t nebulouslabs/sia:ci .

stop:
	docker stop $(docker ps -a -q --filter "name=$(name)") && docker rm $(docker ps -a -q --filter "name=$(name)")

.PHONY: all default release alpine pi dev debug ci stop
