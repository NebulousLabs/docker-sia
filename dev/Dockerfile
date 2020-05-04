FROM golang AS builder
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV GOOS linux
ENV GOARCH amd64

# Fetches the sha of the latest commit on the master branch that passed CI.
COPY dev/master_sha.go .

RUN export SHA=`go run master_sha.go` && \
    go get -d -u gitlab.com/NebulousLabs/Sia/... && \
    cd $GOPATH/src/gitlab.com/NebulousLabs/Sia && \
    git reset --hard $SHA && \
    make release

FROM alpine:3
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"
LABEL autoheal=true

RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    apk add --no-cache socat

ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"

WORKDIR "$SIA_DIR"

ENV SIA_DATA_DIR "$SIA_DATA_DIR"
ENV SIA_MODULES gctwhr

COPY --from=builder /go/bin/siad .
COPY --from=builder /go/bin/siac .
COPY healthcheck.sh .
COPY run.sh .

HEALTHCHECK --interval=10s CMD ["./healthcheck.sh"]

ENTRYPOINT ["./run.sh"]
