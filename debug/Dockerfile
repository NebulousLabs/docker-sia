FROM golang:1.15
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV GOOS linux
ENV GOARCH amd64

WORKDIR /root

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get -y install python3-pip sudo wget curl zip vim nano nload psmisc less mime-support logrotate cron && \
    apt-get clean && \
    mv /etc/cron.daily/logrotate /etc/cron.hourly && \
    wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.30.0 && \
    pip3 install codespell && \
    go get -d -u gitlab.com/NebulousLabs/Sia/... && \
    go get gitlab.com/NebulousLabs/analyze && \
    ln -s $GOPATH/src/gitlab.com/NebulousLabs/Sia ./ && \
    cd $GOPATH/src/gitlab.com/NebulousLabs/Sia && \
    make release && \
    cd

# Setup the actual Sia environment.
ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"
ARG SIAD_DATA_DIR="/sia-data"

COPY ./debug/.vimrc ./debug/.bashrc scripts/*.sh ./
COPY scripts/logrotate-sia /etc/logrotate.d/sia

ENV SIA_DATA_DIR "$SIA_DATA_DIR"
ENV SIAD_DATA_DIR "$SIAD_DATA_DIR"
ENV SIA_MODULES gctwhr

EXPOSE 9980

ENTRYPOINT ["./run.sh"]
