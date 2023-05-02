package main

import (
	"context"
	"fmt"
	"time"
)

type data struct {
	UserID string
}

func main() {
	// Set a duration.
	duration := 3000 * time.Millisecond

	// Create a context that is both manually cancellable and will signal
	// a cancel at the specified duration.
	ctx, cancel := context.WithTimeout(context.Background(), duration)
	//ctx, cancel := context.WithCancel(ctx)
	ctx, cancel = context.WithCancel(ctx)
	//defer cancel()

	// Create a channel to received a signal that work is done.
	ch := make(chan data, 1)

	// Ask the goroutine to do some work for us.
	go func(c context.Context) {

		// Simulate work.
		time.Sleep(4000 * time.Millisecond)

		fmt.Println("Calling done")
		ch <- data{"123"}
		time.Sleep(5000 * time.Millisecond)
		<-c.Done()

		fmt.Println("done ", c.Err())

		return
	}(ctx)

	// Wait for the work to finish. If it takes too long move on.
	select {
	case d := <-ch:
		fmt.Println("work complete", d)

	case <-ctx.Done():
		fmt.Println("work cancelled")
	}
	fmt.Println("cancel")
	cancel()
	fmt.Println("after cancel ", ctx.Err())
	time.Sleep(1000 * time.Millisecond)
}
