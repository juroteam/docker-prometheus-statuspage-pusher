FROM golang:1.17-alpine
ENV PSP_VERSION=1.0.1
WORKDIR /psp
RUN apk add --no-cache git upx \
    && go get github.com/pwaller/goupx \
    && wget -O psp.tar.gz https://github.com/product-os/prometheus-statuspage-pusher/releases/download/v${PSP_VERSION}/prometheus-statuspage-pusher_${PSP_VERSION}_Linux_x86_64.tar.gz \
    && tar zxf psp.tar.gz \
    && goupx prometheus-statuspage-pusher

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=0 /psp/prometheus-statuspage-pusher /
ENTRYPOINT ["/prometheus-statuspage-pusher"]
