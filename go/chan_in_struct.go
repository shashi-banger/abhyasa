package main

import (
	"fmt"
	"time"
)

type foo struct {
	c chan int
}

func main() {
	f := foo{}
	f.c = make(chan int)
	go func() {
		time.Sleep(1)
		f.c <- 1
	}()

	v := <-f.c
	fmt.Println(v)

}
