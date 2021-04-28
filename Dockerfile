FROM alpine:3.9


RUN wget https://github.com/hadolint/hadolint/releases/download/v1.17.1/hadolint-Linux-x86_64 -O /bin/hadolint
RUN chmod 777 /bin/hadolint

# update versions from https://pkgs.alpinelinux.org/packages
RUN apk add --no-cache npm==10.19.0-r0 python3==3.6.9-r3 git==2.20.4-r0 gcc python3-dev musl-dev
RUN python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip
RUN pip3 install --upgrade pip==18.1 setuptools==40.6.2

RUN ln -s pip3 /usr/bin/pip && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    rm -r /root/.cache

RUN pip install black==20.8b1 flake8==3.8.4 autoflake==1.4 isort==5.6.4
RUN npm install --global prettier@2.0.4 globby@6.1.0

RUN mkdir /app
WORKDIR /app

COPY lint /bin/lint
