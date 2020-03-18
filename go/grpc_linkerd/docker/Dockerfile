##### build stage ###########################################################
FROM ubuntu:18.04 as golang

COPY greeter.tgz /root/

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8
ENV GOVERSION 1.14
ENV GOROOT /opt/go
ENV GOPATH /root/go
ENV PATH $PATH:$GOPATH/bin

RUN apt-get update && apt-get install -y wget curl git unzip &&\
    PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip &&\
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/$PROTOC_ZIP &&\
    unzip -o $PROTOC_ZIP -d /usr/local bin/protoc &&\
    unzip -o $PROTOC_ZIP -d /usr/local 'include/*' &&\
    cd /opt && wget https://dl.google.com/go/go1.14.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    ln -s /opt/go/bin/go /usr/bin/ && \
    mkdir $GOPATH

RUN go get -u github.com/golang/protobuf/protoc-gen-go
RUN cd /root/ && tar -zxvf greeter.tgz && ./build.sh

##### run stage #############################################################
FROM ubuntu:18.04

COPY --from=golang /root/greeter_server  /usr/local/bin/greeter_server
COPY --from=golang /root/greeter_client  /usr/local/bin/greeter_client

#ENTRYPOINT ["/usr/local/bin/greeter_server"]
