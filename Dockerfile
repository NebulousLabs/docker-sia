FROM debian:jessie-slim
LABEL maintainer="Michael Lynch <michael@mtlynch.io>"

ENV SIA_VERSION 1.3.2
ENV SIA_PACKAGE Sia-v$SIA_VERSION-linux-amd64
ENV SIA_ZIP ${SIA_PACKAGE}.zip
ENV SIA_RELEASE https://github.com/NebulousLabs/Sia/releases/download/v$SIA_VERSION/$SIA_ZIP
ENV SIA_DIR "/opt/${SIA_PACKAGE}"
ENV SIA_MODULES gctwhr
ENV SIA_DATA_DIR /sia-data

RUN apt-get update && apt-get install -y \
  socat \
  wget \
  unzip

RUN wget "$SIA_RELEASE" && \
      unzip "$SIA_ZIP" -d /opt

EXPOSE 9980 9981 9982

WORKDIR "$SIA_DIR"
ENTRYPOINT socat tcp-listen:9980,reuseaddr,fork tcp:localhost:8000 & ./siad --modules "$SIA_MODULES" --sia-directory "$SIA_DATA_DIR" --api-addr "localhost:8000"
