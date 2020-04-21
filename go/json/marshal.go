package main

import (
	"encoding/json"
	"fmt"
	"os"
)

func main() {
	type ColorGroup struct {
		ID     int
		Name   string
		Colors []string
	}
	group := ColorGroup{
		ID:     1,
		Name:   "Reds",
		Colors: []string{"Crimson", "Red", "Ruby", "Maroon"},
	}
	group1 := ColorGroup{
		ID:     1,
		Name:   "Rubys",
		Colors: []string{"Crimson", "Red", "Ruby", "Maroon"},
	}

    allgroups := []ColorGroup{group, group1}

	b, err := json.Marshal(allgroups)
	if err != nil {
		fmt.Println("error:", err)
	}
	os.Stdout.Write(b)
}
