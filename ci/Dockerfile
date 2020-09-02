FROM golang:1.15
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

RUN apt-get update && \
    apt-get -y install python3-pip && \
    apt-get clean && \
    wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.30.0 && \
    pip3 install codespell
