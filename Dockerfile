FROM alpine:3.15

# BUILDARCH will be: linux/amd64 => amd64, linux/arm64, linx/arm/v7, ... => arm64
ARG TARGETARCH
ARG HADOLINT_VERSION=v2.12.0

# hadolint ignore=SC2086
RUN export DISTRIB=$(case "$TARGETARCH" in amd64) echo "x86_64";; arm64) echo "arm64";; *) echo "Unsupported architecture $TARGETARCH" && exit 1;; esac) && \
  wget -q https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-$DISTRIB -O /bin/hadolint && \
  chmod 777 /bin/hadolint

# update versions from https://pkgs.alpinelinux.org/packages
# hadolint ignore=DL3018
RUN apk add --no-cache python3 git gcc python3-dev musl-dev

# hadolint ignore=DL3013
RUN python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    pip install --no-cache-dir ruff==0.1.4 && \
    mkdir /app

WORKDIR /app

COPY lint /bin/lint
COPY ruff.toml /presets/ruff.toml

# Add safe.directory to git to make the --staged option work
# Use --system so it applies to all users.
# This can't be limited to /app since gitlab-ci mounts the workspace somewhere else
# (see https://github.com/pypa/setuptools_scm/issues/797)
RUN git config --system --add safe.directory '*'
