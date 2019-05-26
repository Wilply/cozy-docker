FROM golang:alpine AS builder

RUN apk --no-cache add git ca-certificates wget

WORKDIR /cozy

RUN VERSION=$(wget -q -O - https://api.github.com/repos/cozy/cozy-stack/releases/latest | grep tag_name | grep -Eo "([0-9]\.)+[0-9]") && \
    wget -O /cozy.tar.gz https://github.com/cozy/cozy-stack/archive/${VERSION}.tar.gz && \
    tar -xzf /cozy.tar.gz -C /tmp && \
    mv /tmp/cozy-stack-${VERSION}/* /cozy

RUN go get -d .

RUN CGO_ENABLED=0 GOOS=linux go build -o cozy-stack -ldflags "-s" -a -installsuffix cgo .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /cozy

COPY --from=builder /cozy/cozy-stack /cozy/cozy-stack

RUN ln -s /cozy/cozy-stack /bin/cozy-stack && \
    chmod 750 /cozy/cozy-stack

COPY root/ /

RUN ls -al

CMD ["/cozy/run.sh"]
#CMD ["sh"]