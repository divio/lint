REGISTRY=
NAME=divio/lint

TARGET=amd64
PLATFORMS=linux/arm/v7,linux/arm64,linux/amd64

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


build: ## Build for the given $TARGET platform (arm64 or amd64)
	docker build -t ${NAME}:latest --platform linux/${TARGET} .

build_multiarch:  ## Build the multi-arch image
	docker buildx build --platform=${PLATFORMS} --tag ${NAME}:latest ${ARGS} .

push_multiarch:  ## push the image to DockerHub
	@if [ "${VERSION}" == "" ]; then echo "VERSION is required"; exit 1; fi
	make -n build_multiarch ARGS="--tag ${NAME}:${VERSION} --push"