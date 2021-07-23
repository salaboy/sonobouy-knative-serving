FROM ubuntu

# Install kubectl
# Note: Latest version may be found on:
# https://aur.archlinux.org/packages/kubectl-bin/

ADD https://storage.googleapis.com/kubernetes-release/release/v1.19.12/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN mkdir config

ENV HOME=/config

# Basic check it works.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get -y install net-tools && \
    apt-get -y install bc && \
    apt-get -y install curl && \
    apt-get -y install wget && \
    apt-get -y install build-essential && \
    chmod +x /usr/local/bin/kubectl

RUN wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz 

RUN wget https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.35.0/ytt-linux-amd64 && \
    cp ytt-linux-amd64 /usr/local/bin/ytt && \
    chmod +x /usr/local/bin/ytt

RUN mkdir $HOME/go

ENV GOPATH=$HOME/go
ENV PATH=$PATH:/usr/local/go/bin

RUN mkdir $GOPATH/serving/ && cd $GOPATH/serving/
WORKDIR $GOPATH/serving/
COPY . $GOPATH/serving/

RUN chmod +x run.sh

ENTRYPOINT ["./run.sh"]