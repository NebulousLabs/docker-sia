FROM debian:stretch-slim AS zip_downloader
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ARG SIA_VERSION="1.4.8"
ARG SIA_PACKAGE="Sia-v${SIA_VERSION}-linux-arm64"
ARG SIA_ZIP="${SIA_PACKAGE}.zip"
ARG SIA_RELEASE="https://sia.tech/releases/${SIA_ZIP}"
#ARG QEMU_BIN="https://github.com/multiarch/qemu-user-static/releases/download/v4.2.0-7/qemu-arm-static"

RUN apt-get update && \
    apt-get install -y wget unzip && \ #qemu binfmt-support qemu-user-static
    wget "$SIA_RELEASE" && \
    mkdir /sia && \
    unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siac" -d /sia && \
    unzip -j "$SIA_ZIP" "${SIA_PACKAGE}/siad" -d /sia
#    && \
#    wget "$QEMU_BIN" && \
#    chmod +x qemu-arm-static

#RUN chmod +x /proc/sys/fs/binfmt_misc
#RUN ls -l /proc/sys/fs/
#RUN ls -l /proc/sys/fs/binfmt_misc
#
#COPY scripts/setup_binfmt_misc.sh /usr/local/bin
#RUN ls -l qemu-arm-static /usr/local/bin
#RUN /usr/local/bin/setup_binfmt_misc.sh

FROM arm64v8/debian:stretch-slim
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"
LABEL autoheal=true

ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"

#COPY --from=zip_downloader qemu-arm-static /usr/local/bin

#RUN chmod +x /usr/bin/qemu-arm-static && \
#    ln -s /usr/bin/qemu-arm-static /usr/local/bin && \
#    ln -s /usr/bin/qemu-arm-static /usr/bin/qemu-arm && \
#    ln -s /usr/bin/qemu-arm /usr/local/bin

RUN apt-get update && apt-get install -y --no-install-recommends socat && apt-get clean

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
