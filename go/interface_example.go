package main

import (
	"fmt"
	"reflect"
)

type transcItem struct {
	PartitionKey string
	SecondaryKey string
	width        int
}

type genvodItem struct {
	PartitionKey string
	SecondaryKey string
	duration     int
	anotherval   string
}

func boo(val interface{}) {
	value := reflect.ValueOf(val).FieldByName("PartitionKey").String()
	fmt.Println(value)
}

func main() {
	t := transcItem{PartitionKey: "key1", SecondaryKey: "skey", width: 280}
	g := genvodItem{PartitionKey: "key2", SecondaryKey: "skey2", duration: 280, anotherval: "ksjdhfskjdfh"}

	boo(t)
	boo(g)
}
