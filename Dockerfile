FROM debian:stretch-slim AS zip_downloader
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ARG SIA_VERSION="1.4.7"
ARG SIA_PACKAGE="Sia-v${SIA_VERSION}-linux-amd64"
ARG SIA_ZIP="${SIA_PACKAGE}.zip"
ARG SIA_RELEASE="https://sia.tech/releases/${SIA_ZIP}"

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget "$SIA_RELEASE" && \
    mkdir /sia && \
    unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siac" -d /sia && \
    unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siad" -d /sia

FROM debian:stretch-slim
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"
LABEL autoheal=true

RUN apt-get update && apt-get install -y --no-install-recommends socat

ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"

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
