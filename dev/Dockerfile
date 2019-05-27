FROM golang:alpine AS builder

RUN apk --no-cache add git ca-certificates wget

WORKDIR /cozy

RUN VERSION=$(wget -q -O - https://api.github.com/repos/cozy/cozy-stack/releases/latest | grep tag_name | grep -Eo "([0-9]\.)+[0-9]") && \
    wget -O /cozy.tar.gz https://github.com/cozy/cozy-stack/archive/${VERSION}.tar.gz && \
    tar -xzf /cozy.tar.gz -C /tmp && \
    mv /tmp/cozy-stack-${VERSION}/* /cozy

RUN go get -d .

COPY test.sh /tmp/test.sh

RUN chmod 777 /tmp/test.sh

CMD ["/tmp/test.sh"]