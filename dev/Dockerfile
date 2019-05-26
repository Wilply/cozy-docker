#FROM debian:stable-slim
FROM golang:alpine

RUN apk --no-cache add git && \
    go get -u github.com/cozy/cozy-stack

FROM alpine:latest

WORKDIR /cozy

COPY --from=0 /go/bin/cozy-stack /cozy/cozy-stack

#RUN apt update && apt install -y wget

#RUN VERSION=$(wget -q -O - https://api.github.com/repos/cozy/cozy-stack/releases/latest | grep tag_name | grep -Eo "([0-9]\.)+[0-9]") && \
#    wget -O cozy-stack https://github.com/cozy/cozy-stack/releases/download/${VERSION}/cozy-stack-linux-amd64 && \
RUN ln -s /cozy/cozy-stack /bin/cozy-stack && \
    chmod 750 /cozy/cozy-stack

COPY root/ /

CMD ["/cozy/run.sh"]
#CMD ["sh"]