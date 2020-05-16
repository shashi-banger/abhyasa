package main

import (
	"bytes"
	"fmt"
	"time"
)

type producer struct {
	bufread chan *bytes.Buffer
}

func NewProducer() *producer {
	p := &producer{}
	p.bufread = make(chan *bytes.Buffer, 6)
	return p
}

func (p *producer) Produce(s string, tms int) {
	for {
		nb := bytes.NewBufferString(s)
		time.Sleep(time.Duration(tms) *
			time.Millisecond)
		p.bufread <- nb
	}
}

func (p *producer) GetChan() chan *bytes.Buffer {
	return p.bufread
}

func main() {
	p1 := NewProducer()
	p2 := NewProducer()

	go p1.Produce("+++", 100)
	go p2.Produce("***", 1000)

	c1 := p1.GetChan()
	c2 := p2.GetChan()

	for i := 0; i < 100; i++ {
		select {
		case b1 := <-c1:
			fmt.Printf("%v==", b1)
		case b2 := <-c2:
			fmt.Printf("%v\n", b2)
		}
	}

}
