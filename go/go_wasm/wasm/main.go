package main

import (
	"encoding/json"
	"fmt"
	"syscall/js"

	"github.com/tidwall/sjson"
)

func prettyJson(input string) (string, error) {
	var raw any
	if err := json.Unmarshal([]byte(input), &raw); err != nil {
		return "", err
	}
	pretty, err := json.MarshalIndent(raw, "", "  ")
	if err != nil {
		return "", err
	}
	return string(pretty), nil
}

func jsonWrapper() js.Func {
	jsonFunc := js.FuncOf(func(this js.Value, args []js.Value) any {
		if len(args) != 1 {
			return "Invalid no of arguments passed"
		}
		inputJSON := args[0].String()
		fmt.Printf("input %s\n", inputJSON)
		newJson, _ := sjson.Set(inputJSON, "name", "sb")
		pretty, err := prettyJson(newJson)
		if err != nil {
			fmt.Printf("unable to convert to json %s\n", err)
			return err.Error()
		}
		return pretty
	})
	return jsonFunc
}

func main() {
	var ch = make(chan struct{})
	fmt.Println("Go Web Assembly")
	js.Global().Set("formatJSON", jsonWrapper())
	fmt.Println("Set formatJSON function to global scope")
	ch <- struct{}{}
}
