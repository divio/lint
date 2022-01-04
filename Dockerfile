FROM alpine:3.15


RUN wget https://github.com/hadolint/hadolint/releases/download/v2.8.0/hadolint-Linux-x86_64 -O /bin/hadolint
RUN chmod 777 /bin/hadolint

# update versions from https://pkgs.alpinelinux.org/packages
RUN apk add --no-cache npm==8.1.3-r0 python3==3.9.7-r4 git==2.34.1-r0 gcc python3-dev musl-dev
RUN python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip
RUN pip3 install --upgrade pip==21.3.1 setuptools==60.2.0

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    rm -r /root/.cache

RUN pip install black==21.12b0 flake8==4.0.1 autoflake==1.4 isort==5.10.1
RUN npm install --global prettier@2.5.1 globby@12.0.2

RUN mkdir /app
WORKDIR /app

COPY lint /bin/lint
