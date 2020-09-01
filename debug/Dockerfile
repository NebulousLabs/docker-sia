FROM golang:1.15
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV GOOS linux
ENV GOARCH amd64

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get -y install python3-pip sudo wget curl zip vim nano nload psmisc less && \
    apt-get clean && \
    wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.30.0 && \
    pip3 install codespell && \
    adduser --home /home/user --disabled-password --gecos "Debugger" user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER user
ENV  USER=user HOME=/home/user
WORKDIR /home/user

COPY ./debug/.vimrc ./

RUN go get -d -u gitlab.com/NebulousLabs/Sia/... && \
    go get gitlab.com/NebulousLabs/analyze && \
    ln -s $GOPATH/src/gitlab.com/NebulousLabs/Sia ./
