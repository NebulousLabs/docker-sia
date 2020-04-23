FROM golang AS builder
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV GOOS linux
ENV GOARCH amd64

RUN go get -d -u gitlab.com/NebulousLabs/Sia/... && \
    cd $GOPATH/src/gitlab.com/NebulousLabs/Sia && \
    make release

FROM alpine
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV SIA_DIR /sia
ENV SIA_DATA_DIR /sia-data
ENV SIA_MODULES gctwhr

RUN apk --no-cache add socat

WORKDIR "$SIA_DIR"
COPY --from=builder /go/bin/siad .
COPY --from=builder /go/bin/siac .
COPY run.sh .

ENTRYPOINT ["./run.sh"]
