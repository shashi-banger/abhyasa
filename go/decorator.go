package main

import (
	"fmt"
	"math/rand"
	"time"
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

type Stop struct {
	error
}

func Retry(attempts int, sleepSec int, f func() error) error {
	if err := f(); err != nil {

		if s, ok := err.(Stop); ok {
			// Return the original error for later checking
			return s.error
		}

		if attempts--; attempts > 0 {
			// Add some randomness to prevent creating a Thundering Herd
			jitter := rand.Intn(sleepSec)
			sleepSec = sleepSec + jitter/2

			time.Sleep(time.Duration(sleepSec) * time.Second)
			return Retry(attempts, sleepSec, f)
		}
		return err
	}

	return nil
}

func foo(a int, s string) (int, error) {
	var err error
	v := rand.Intn(20)
	fmt.Println(a)
	fmt.Println(s, v)

	if v > 10 {
		err = nil
	} else if v <= 7 && v > 3 {
		err = Stop{fmt.Errorf("AcceptFailed")}
	} else {
		err = fmt.Errorf("failed")
	}
	return v, err
}

func main() {
	a := 3
	b := "hi"
	fmt.Println(time.Now().Unix())
	rand.Seed(time.Now().Unix())

	err := Retry(5, 1, func() error {
		_, err := foo(a, b)
		return err
	})
	//r, err := foo(a, b)

	fmt.Println(err)
	//fn1 := Retry(a, b, foo)
	//fn1(&a, "banger")
}
