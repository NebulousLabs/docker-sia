FROM debian:stretch-slim AS zip_downloader
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ARG SIA_VERSION="1.4.8"
ARG SIA_PACKAGE="Sia-v${SIA_VERSION}-linux-arm64"
ARG SIA_ZIP="${SIA_PACKAGE}.zip"
ARG SIA_RELEASE="https://sia.tech/releases/${SIA_ZIP}"

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget "$SIA_RELEASE" && \
    mkdir /sia && \
    unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siac" -d /sia && \
    unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siad" -d /sia

FROM arm64v8/debian:stretch-slim
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"
LABEL autoheal=true

ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"

RUN ls

RUN apt-get update && apt-get install -y --no-install-recommends socat

# Workaround for backwards compatibility with old images, which hardcoded the
# Sia data directory as /mnt/sia. Creates a symbolic link so that any previous
# path references stored in the Sia host config still work.
RUN ln -s "$SIA_DATA_DIR" /mnt/sia

WORKDIR "$SIA_DIR"

ENV SIA_DATA_DIR "$SIA_DATA_DIR"
ENV SIA_MODULES gctwhr

COPY --from=zip_downloader /sia/siac .
COPY --from=zip_downloader /sia/siad .
COPY scripts/healthcheck.sh .
COPY scripts/run.sh .

EXPOSE 9980 9981 9982

HEALTHCHECK --interval=10s CMD ["./healthcheck.sh"]

ENTRYPOINT ["./run.sh"]
