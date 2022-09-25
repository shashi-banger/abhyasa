package main

import (
	"context"
	"fmt"
	"sync"
	"time"
)

var wg sync.WaitGroup

func activity(c context.Context) {
	defer wg.Done()
	for i := 0; i < 10; i++ {
		fmt.Printf("Sleeping %d\n", i)
		select {
		case <-time.After(time.Second):
			continue
		case <-c.Done():
			return
		}
	}
}

func activity1(c context.Context) {
	defer wg.Done()
	for i := 0; i < 15; i++ {
		fmt.Printf("Thrd 1: Sleeping %d\n", i)
		select {
		case <-time.After(time.Second):
			continue
		case <-c.Done():
			return
		}
	}
}

func main() {
	// Set a duration.
	duration := 3000 * time.Millisecond
	wg.Add(2)

	// Create a context that is both manually cancellable and will signal
	// a cancel at the specified duration.
	ctx, cancel := context.WithTimeout(context.Background(), duration)
	defer cancel()

	go activity(ctx)
	go activity1(ctx)
	wg.Wait()
	<-ctx.Done()

	fmt.Printf("Completed\n")

}
