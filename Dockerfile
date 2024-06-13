FROM alpine:3.20

# BUILDARCH will be: linux/amd64 => amd64, linux/arm64, linx/arm/v7, ... => arm64
ARG TARGETARCH
ARG HADOLINT_VERSION=v2.12.0
ARG RUFF_VERSION=0.4.8

# allow the install without a virtualenv
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# hadolint ignore=SC2086
RUN export DISTRIB=$(case "$TARGETARCH" in amd64) echo "x86_64";; arm64) echo "arm64";; *) echo "Unsupported architecture $TARGETARCH" && exit 1;; esac) && \
  wget -q https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-$DISTRIB -O /bin/hadolint && \
  chmod 777 /bin/hadolint && \
  apk add --no-cache git python3 py3-pip && \
  pip install --no-cache-dir ruff && \
  mkdir /app

# Add safe.directory to git to make the --staged option work \
# Use --system so it applies to all users. \
# This can't be limited to /app since gitlab-ci mounts the workspace somewhere else \
# (see https://github.com/pypa/setuptools_scm/issues/797) \
RUN git config --system --add safe.directory '*'

WORKDIR /app

COPY lint /bin/lint
COPY ruff.toml /presets/ruff.toml

