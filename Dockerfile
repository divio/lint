FROM alpine:3.15

# BUILDARCH will be: linux/amd64 => amd64, linux/arm64, linx/arm/v7, ... => arm64
ARG BUILDARCH
ARG HADOLINT_VERSION=v2.12.0

RUN export DISTRIB=$(case "$BUILDARCH" in amd64) echo "x86_64";; arm64) echo "arm64";; *) echo "Unsupported architecture $BUILDARCH" && exit 1;; esac) \
  && wget https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-$DISTRIB -O /bin/hadolint
RUN chmod 777 /bin/hadolint

# update versions from https://pkgs.alpinelinux.org/packages
RUN apk add --no-cache npm==8.1.3-r0 python3==3.9.16-r0 git gcc python3-dev musl-dev

RUN python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip
RUN pip3 install --upgrade pip==21.3.1 setuptools==60.2.0

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    rm -r /root/.cache

RUN pip install black==22.3.0 ruff==0.0.263
RUN npm install --global prettier@2.5.1 globby@12.0.2

RUN mkdir /app
WORKDIR /app

COPY lint /bin/lint
COPY ruff.toml /presets/ruff.toml
