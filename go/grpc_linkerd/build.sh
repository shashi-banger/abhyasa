#!/bin/bash
protoc -I ./proto/ ./proto/serve.proto --go_out=plugins=grpc:proto
go build greeter_server.go
go build client/greeter_client.go
