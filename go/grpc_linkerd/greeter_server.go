package main

import (
	"context"
	"log"
	"net"
	"os"
	"fmt"

	"google.golang.org/grpc"
	pb "google.golang.org/grpc/examples/helloworld/helloworld"
)

const (
	port = "9000"
)

// server is used to implement helloworld.GreeterServer.
type server struct {
	pb.UnimplementedGreeterServer
}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", in.GetName())
	name, _ := os.Hostname()
	return &pb.HelloReply{Message: "Hello " + in.GetName() + " " + name}, nil
}

func main() {
	log.Printf("Starting grpc-greeter-lb Entered Main\n")

	name, err := os.Hostname()
	if err != nil {
		log.Fatalf("Oops: %v\n", err)
	}

	addrs, err := net.LookupHost(name)
	if err != nil {
		log.Fatalf("Oops: %v\n", err)
	}

	addr_port := fmt.Sprintf("%s:%s", addrs[0], port)
	log.Printf("Server Addres: %s", addr_port)

	lis, err := net.Listen("tcp", addr_port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})
	log.Printf("Starting grpc-greeter-lb Calling Serve\n")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}