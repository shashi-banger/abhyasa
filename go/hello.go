package main

import (
        "fmt"
       "time"
)

type Node struct {
	val  int
	label string
}

func gen_first_10_even() (event_list [10]int) {
	var a [10]int
	for i := 0; i < 10; i++ {
		a[i] = 2*i
	}
	return a
}

func add_num(a int, b int) (n int) {
	return a + b
}

func main() { 
	fmt.Println("hello World")
	fmt.Println(add_num(3,4))
	even_list := gen_first_10_even()
	fmt.Println(even_list)

    str_val := ""
    str_val += fmt.Sprintf("%d, ", 10)

    fmt.Printf("======%s \n", str_val)
	
	fmt.Println(time.Now())
}
