NAME=divio/lint
TAG=latest

TARGET=amd64
# Hadolint doesn't support arm32...
PLATFORMS=linux/arm64,linux/amd64

.PHONY: help lint
help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

lint: ## Lint the Dockerfile with hadolint
	docker run --rm -it --env-file=.lint -v $(PWD):/app divio/lint /bin/lint --run=docker

build: ## Build for the given $TARGET platform (arm64 or amd64)
	docker build -t ${NAME}:${TAG} --platform linux/${TARGET} .

build_multiarch:  ## Build the multi-arch image
	docker buildx build --platform=${PLATFORMS} --tag ${NAME}:${TAG} ${ARGS} .

# DEPRECATED: create a git tag, push and let the Gitlab pipeline do the rest
push_multiarch:  ## (DEPRECATED) Push the image to DockerHub
	@if [ "${VERSION}" == "" ]; then echo "VERSION is required"; exit 1; fi
	make build_multiarch ARGS="--tag ${NAME}:${VERSION} --push"