FROM debian:jessie-slim
LABEL maintainer="Michael Lynch <michael@mtlynch.io>"

ENV SIA_VERSION 1.3.2
ENV SIA_PACKAGE Sia-v$SIA_VERSION-linux-amd64
ENV SIA_ZIP ${SIA_PACKAGE}.zip
ENV SIA_RELEASE https://github.com/NebulousLabs/Sia/releases/download/v$SIA_VERSION/$SIA_ZIP
ENV SIA_DIR /opt/$SIA_PACKAGE

RUN apt-get update && apt-get install -y \
  socat \
  wget \
  unzip

# Download and install Sia.
RUN wget $SIA_RELEASE
RUN unzip $SIA_ZIP -d /opt

# Make the Sia ports available to the Docker container's host.
EXPOSE 9980 9981 9982

# of Docker.
WORKDIR $SIA_DIR
ENTRYPOINT socat tcp-listen:9980,reuseaddr,fork tcp:localhost:8000 & ./siad --modules gctwhr --sia-directory /mnt/sia --api-addr "localhost:8000"
