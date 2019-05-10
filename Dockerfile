FROM alpine:3.9

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN pip install black==19.3b0 flake8==3.7.5 autoflake==1.2 isort==4.3.18
COPY lint /bin/lint
RUN mkdir /app



RUN apk add --update nodejs-npm
RUN npm install --global prettier


WORKDIR /app 

