// Package main implements a client for Greeter service.
package main

import (
	"context"
	"flag"
	"log"
	"strconv"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/balancer/roundrobin"
	pb "google.golang.org/grpc/examples/helloworld/helloworld"
)

const (
	address     = "localhost:9000"
	defaultName = "world"
)

func main() {
	var a = flag.String("a", address, "greeter service address")
	var m = flag.String("m", "local", "kubernetes or local")
	var err error
	var conn *grpc.ClientConn
	flag.Parse()

	// Set up a connection to the server.
	//if *m == "local" {
	//	conn, err = grpc.Dial(*a, grpc.WithInsecure(), grpc.WithBlock())
	//}

	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	//defer conn.Close()
	//c := pb.NewGreeterClient(conn)

	if *m == "local" {
		conn, err = grpc.Dial(*a, grpc.WithInsecure(), grpc.WithBlock())
	} else if *m == "kubernetes" {
		log.Printf("Dialling service dns:///greeter-server-lb\n")
		conn, err = grpc.Dial(
			"dns:///greeter-server-lb:9000",
			grpc.WithInsecure(), 
			grpc.WithBlock(),
			grpc.WithBalancerName(roundrobin.Name))
		if err != nil {
			log.Fatalf("grpc.Dial Error %v", err)
		}
		log.Printf("Dialling service completed-1\n")

	} else {
		log.Fatalf("could not greet: %v", err)
	}
	c := pb.NewGreeterClient(conn)

	// Contact the server and print out its response.
	name := defaultName
	start := time.Now()
	for i := 0; i < 500000; i++ {
		ctx, cancel := context.WithTimeout(context.Background(), time.Second*20)
		defer cancel()
		r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name + strconv.Itoa(i)})
		if err != nil {
			log.Fatalf("could not greet: %v", err)
		}
		log.Printf("Greeting: %s", r.GetMessage())
	}
	endT := time.Now()
	elapsed := endT.Sub(start)
	conn.Close()
	log.Printf("Elapsed_time=%d", elapsed.Milliseconds())

}
