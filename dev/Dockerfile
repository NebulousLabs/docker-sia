FROM golang AS builder
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV GOOS linux
ENV GOARCH amd64

ARG SHA
ARG TAG

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

ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"
ARG SIAD_DATA_DIR="/sia-data"

RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    apk add --no-cache socat

# Workaround for backwards compatibility with old images, which hardcoded the
# Sia data directory as /mnt/sia. Creates a symbolic link so that any previous
# path references stored in the Sia host config still work.
RUN ln -s "$SIA_DATA_DIR" /mnt/sia

WORKDIR "$SIA_DIR"

ENV SIA_DATA_DIR "$SIA_DATA_DIR"
ENV SIAD_DATA_DIR "$SIAD_DATA_DIR"
ENV SIA_MODULES gctwhr

COPY --from=builder /go/bin/siac /go/bin/siad /usr/bin/
COPY scripts/*.sh ./

EXPOSE 9980 9981 9982

HEALTHCHECK --interval=10s CMD ["./healthcheck.sh"]

ENTRYPOINT ["./run.sh"]
