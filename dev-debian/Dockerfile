FROM golang AS builder
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV GOOS linux
ENV GOARCH amd64
ENV GO111MODULE on

ARG SHA
ARG TAG

# Fetches the sha of the latest commit on the master branch that passed CI.
# This is overriden by the manually supplied TAG and SHA values. That's done
# in the Go code.
COPY scripts/master_sha.go .

RUN SHA=`go run master_sha.go` && \
    git clone https://gitlab.com/NebulousLabs/Sia.git && \
    cd Sia && \
    git reset --hard $SHA && \
    make release

FROM debian:stretch-slim
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"
ARG SIAD_DATA_DIR="/sia-data"

RUN apt-get update && apt-get install -y mime-support logrotate cron && \
    mv /etc/cron.daily/logrotate /etc/cron.hourly

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
COPY scripts/logrotate-sia /etc/logrotate.d/sia

EXPOSE 9980

ENTRYPOINT ["./run.sh"]
