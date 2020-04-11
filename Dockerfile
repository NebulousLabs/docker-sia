FROM debian:stretch-slim AS zip_downloader
LABEL maintainer="NebulousLabs <developers@nebulous.tech>"

ARG SIA_VERSION="1.4.7"
ARG SIA_PACKAGE="Sia-v${SIA_VERSION}-linux-amd64"
ARG SIA_ZIP="${SIA_PACKAGE}.zip"
ARG SIA_RELEASE="https://sia.tech/releases/${SIA_ZIP}"

RUN apt-get update
RUN apt-get install -y wget unzip

RUN wget "$SIA_RELEASE" && \
      mkdir /sia && \
      unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siac" -d /sia && \
      unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siad" -d /sia

FROM debian:stretch-slim
LABEL maintainer="NebulousLabs <developers@nebulous.tech>"
ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"

COPY --from=zip_downloader /sia/siac "${SIA_DIR}/siac"
COPY --from=zip_downloader /sia/siad "${SIA_DIR}/siad"

RUN apt-get update
RUN apt-get install -y socat

# Workaround for backwards compatibility with old images, which hardcoded the
# Sia data directory as /mnt/sia. Creates a symbolic link so that any previous
# path references stored in the Sia host config still work.
RUN ln --symbolic "$SIA_DATA_DIR" /mnt/sia

EXPOSE 9980 9981 9982

WORKDIR "$SIA_DIR"

ENV SIA_DATA_DIR "$SIA_DATA_DIR"
ENV SIA_MODULES gctwhr

ENTRYPOINT socat tcp-listen:9980,reuseaddr,fork tcp:localhost:8000 & \
  ./siad \
    --modules "$SIA_MODULES" \
    --sia-directory "$SIA_DATA_DIR" \
    --api-addr "localhost:8000"
