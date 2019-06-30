FROM golang:alpine AS builder

ARG VERSION

RUN apk --no-cache add git ca-certificates wget

RUN [ -z "${VERSION}" ] && echo $(wget -q -O - https://api.github.com/repos/cozy/cozy-stack/releases/latest | grep tag_name | grep -Eo "([0-9]\.)+[0-9]") > /VERSION

WORKDIR /cozy

RUN VERSION=$(cat /VERSION) && \
    wget -q -O /cozy.tar.gz https://github.com/cozy/cozy-stack/archive/${VERSION}.tar.gz && \
    tar -xzf /cozy.tar.gz -C /tmp && \
    mv /tmp/cozy-stack-${VERSION}/* /cozy

RUN go get -d .

RUN VERSION=$(cat /VERSION) && CGO_ENABLED=0 GOOS=linux \
    go build \
    #build a production release
    #needed because else builded as dev and causes problems like not asking for admin password
    -ldflags "  -X github.com/cozy/cozy-stack/pkg/config.BuildMode=production \
                -X github.com/cozy/cozy-stack/pkg/config.Version=${VERSION} \
                -s " \
    -o cozy-stack -a .

FROM alpine:latest

RUN apk --no-cache add ca-certificates imagemagick

WORKDIR /cozy

RUN mkdir /cozy/storage /cozy/config

COPY --from=builder /cozy/cozy-stack /cozy/cozy-stack

RUN ln -s /cozy/cozy-stack /bin/cozy-stack && \
    chmod 750 /cozy/cozy-stack

COPY root/ /

CMD ["/run.sh"]