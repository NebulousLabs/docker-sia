FROM debian:stretch-slim AS zip_downloader
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ARG SIA_VERSION="1.4.7"
ARG SIA_PACKAGE="Sia-v${SIA_VERSION}-linux-amd64"
ARG SIA_ZIP="${SIA_PACKAGE}.zip"
ARG SIA_RELEASE="https://sia.tech/releases/${SIA_ZIP}"

RUN apt-get update && apt-get install -y wget unzip

RUN wget "$SIA_RELEASE" && \
      mkdir /sia && \
      unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siac" -d /sia && \
      unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siad" -d /sia

FROM alpine:3
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"
ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"

RUN mkdir /lib64 && \
      ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
      apk add --no-cache socat
COPY --from=zip_downloader /sia/siac "${SIA_DIR}/siac"
COPY --from=zip_downloader /sia/siad "${SIA_DIR}/siad"

# Workaround for backwards compatibility with old images, which hardcoded the
# Sia data directory as /mnt/sia. Creates a symbolic link so that any previous
# path references stored in the Sia host config still work.
RUN ln -s "$SIA_DATA_DIR" /mnt/sia

EXPOSE 9980 9981 9982

WORKDIR "$SIA_DIR"

ENV SIA_DATA_DIR "$SIA_DATA_DIR"
ENV SIA_MODULES gctwhr

COPY healthcheck.sh .
COPY run.sh .

HEALTHCHECK --interval=10s CMD ["./healthcheck.sh"]

ENTRYPOINT ["./run.sh"]