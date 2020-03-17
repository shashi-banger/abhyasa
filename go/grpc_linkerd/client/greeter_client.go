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
	address     = "localhost:50051"
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

	// Contact the server and print out its response.
	name := defaultName

	start := time.Now()
	for i := 0; i < 5000; i++ {
		if *m == "local" {
			conn, err = grpc.Dial(*a, grpc.WithInsecure(), grpc.WithBlock())
		} else if *m == "kubernetes" {
			conn, err = grpc.Dial("dns:///greeter-server-lb.default.svc.cluster.local",
				grpc.WithInsecure(), grpc.WithBlock(),
				grpc.WithBalancerName(roundrobin.Name))
		} else {
			log.Fatalf("could not greet: %v", err)
		}
		c := pb.NewGreeterClient(conn)
		ctx, cancel := context.WithTimeout(context.Background(), time.Second)
		defer cancel()
		r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name + strconv.Itoa(i)})
		if err != nil {
			log.Fatalf("could not greet: %v", err)
		}
		log.Printf("Greeting: %s", r.GetMessage())
		conn.Close()
	}
	endT := time.Now()
	elapsed := endT.Sub(start)
	log.Printf("Elapsed_time=%d", elapsed.Milliseconds())

}
