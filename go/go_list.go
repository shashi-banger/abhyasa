package main

import (
	"container/list"
	"fmt"
)

func main() {
	l := list.List{}

	for i := 0; i < 10; i++ {
		l.PushBack(i)
	}

	for v := l.Front(); v != nil; {
		fmt.Println("Value ", v.Value)
		nxt := v.Next()
		if v.Value.(int)%2 == 0 {
			fmt.Println("Removing ", v.Value)
			l.Remove(v)
		}
		v = nxt
	}

	for v := l.Front(); v != nil; v = v.Next() {
		fmt.Println(v.Value)
	}
}
