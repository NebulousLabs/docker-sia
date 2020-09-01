FROM golang

ENV GOOS linux
ENV GOARCH amd64

ARG branch=master
ARG SIA_DIR="/sia"
ARG SIA_DATA_DIR="/sia-data"
ARG SIAD_DATA_DIR="/sia-data"

ENV SIA_DATA_DIR "$SIA_DATA_DIR"
ENV SIAD_DATA_DIR "$SIAD_DATA_DIR"
ENV SIA_MODULES gctwhr

WORKDIR "$SIA_DIR"

# add gopath to path
RUN export PATH=$PATH:$(go env GOPATH)/bin

# clone the run scripts
COPY scripts/*.sh ./

# install any necessary packages
RUN apt-get update && apt-get install -qq curl

# clone full Sia repo and make release
RUN git clone https://gitlab.com/NebulousLabs/Sia.git
RUN cd Sia
RUN git checkout ${branch}
RUN make release

EXPOSE 9980

ENTRYPOINT ["./run.sh"]
