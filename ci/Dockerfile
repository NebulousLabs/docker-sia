FROM golang:1.15
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV GO111MODULE on

RUN apt --allow-releaseinfo-change update && \
    apt -y install python3-pip && \
    apt-get clean && \
    wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.30.0 && \
    pip3 install codespell && \
    go get gitlab.com/NebulousLabs/analyze
