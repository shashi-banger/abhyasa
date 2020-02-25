package main
import "intset"
import "fmt"

func main() {
	var x intset.IntSet

	x.Add(3)
	x.Add(75)
	x.Add(189)

	ret_str := x.String()
	fmt.Printf("%s\n", ret_str)
}