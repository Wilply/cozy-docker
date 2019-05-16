FROM golang:alpine

RUN apk --no-cache add git && \
    go get -u github.com/cozy/cozy-stack

FROM alpine:latest

WORKDIR /cozy

COPY --from=0 /go/bin/cozy-stack /cozy/cozy-stack

RUN ln -s /cozy/cozy-stack /bin/cozy-stack

COPY root/ /

CMD ["/cozy/run.sh"]
#CMD ["sh"]