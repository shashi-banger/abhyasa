package main

import (
	"crypto/rand"
	"fmt"
	"os"
)

var charMap map[int]byte

// UUID Represents a UUID
type UUID [16]byte

func init() {
	var i byte
	index := 0
	charMap = make(map[int]byte)
	// Initializing a to z
	for i = 0x61; i < 0x7b; i++ {
		charMap[index] = i
		index += 1
	}
	// Initializing from A to Z
	/*for i = 0x41; i < 0x5B; i++ {
		charMap[index] = i
		index += 1
	}*/
	// Initializing from 0 to 9
	for i = 0x30; i < 0x3a; i++ {
		charMap[index] = i
		index += 1
	}
}

func UUIDn(n int) string {
	bytes := make([]byte, n)
	_, _ = rand.Read(bytes)
	result := []byte{}
	for i := 0; i < n; i++ {
		result = append(result, charMap[int(bytes[i])%(len(charMap))])

	}
	return string(result)
}

func main() {
	var s string
	uuids := map[string]interface{}{}
	for i := 0; i < 100000000; i++ {
		s = UUIDn(11)
		if _, ok := uuids[s]; !ok {
			uuids[s] = 1
		} else {
			fmt.Println("Found duplicate", s, i)
			os.Exit(1)
		}

	}
	os.Exit(0)
}
