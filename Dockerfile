FROM debian:stretch-slim AS zip_downloader
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ARG SIA_VERSION="1.5.0"
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

ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"
ARG SIAD_DATA_DIR="/sia-data"
ARG USER="sia"
ARG UID=514
ARG GID=514

RUN apt-get update && apt-get install -y mime-support

# Workaround for backwards compatibility with old images, which hardcoded the
# Sia data directory as /mnt/sia. Creates a symbolic link so that any previous
# path references stored in the Sia host config still work.
RUN ln -s "$SIA_DATA_DIR" /mnt/sia

WORKDIR "$SIA_DIR"

ENV SIA_DATA_DIR "$SIA_DATA_DIR"
ENV SIAD_DATA_DIR "$SIAD_DATA_DIR"
ENV SIA_MODULES gctwhr

COPY --from=zip_downloader /sia/siac /sia/siad /usr/bin/
COPY scripts/*.sh ./

# Process in container should not run as root
RUN groupadd -g ${GID} ${USER} && \
    useradd -r -u ${UID} -g ${USER} -d "$SIAD_DATA_DIR" ${USER} && \

    mkdir -p "$SIA_DATA_DIR" "$SIAD_DATA_DIR" && \
    chmod 750 "$SIA_DATA_DIR" "$SIAD_DATA_DIR" && \  

    chown ${UID}:${GID} "$SIA_DATA_DIR" "$SIAD_DATA_DIR" && \
        
    mkdir -p "$SIAD_DATA_DIR"/wallet && chmod 750 "$SIAD_DATA_DIR"/wallet && chown ${UID}:${GID} "$SIAD_DATA_DIR"/wallet && \
    mkdir -p "$SIAD_DATA_DIR"/transactionpool && chmod 750 "$SIAD_DATA_DIR"/transactionpool && chown ${UID}:${GID} "$SIAD_DATA_DIR"/transactionpool && \
    mkdir -p "$SIAD_DATA_DIR"/siamux && chmod 750 "$SIAD_DATA_DIR"/siamux && chown ${UID}:${GID} "$SIAD_DATA_DIR"/siamux && \
    mkdir -p "$SIAD_DATA_DIR"/renter && chmod 750 "$SIAD_DATA_DIR"/renter && chown ${UID}:${GID} "$SIAD_DATA_DIR"/renter && \
    mkdir -p "$SIAD_DATA_DIR"/host && chmod 750 "$SIAD_DATA_DIR"/host && chown ${UID}:${GID} "$SIAD_DATA_DIR"/host && \
    mkdir -p "$SIAD_DATA_DIR"/host/contractmanager && chmod 750 "$SIAD_DATA_DIR"/host/contractmanager && chown ${UID}:${GID} "$SIAD_DATA_DIR"/host/contractmanager && \
    mkdir -p "$SIAD_DATA_DIR"/gateway && chmod 750 "$SIAD_DATA_DIR"/gateway && chown ${UID}:${GID} "$SIAD_DATA_DIR"/gateway && \
    mkdir -p "$SIAD_DATA_DIR"/consensus && chmod 750 "$SIAD_DATA_DIR"/consensus && chown ${UID}:${GID} "$SIAD_DATA_DIR"/consensus    
USER sia

# Workaround for log to stdout
RUN ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/wallet/wallet.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/transactionpool/transactionpool.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/siamux/siamux.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/renter/repair.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/renter/renter.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/renter/hostdb.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/renter/contractor.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/host/host.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/host/contractmanager/contractmanager.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/gateway/gateway.log &&\
    ln -sf /proc/1/fd/1 "$SIAD_DATA_DIR"/consensus/consensus.log

EXPOSE 9980

ENTRYPOINT ["./run.sh"]
