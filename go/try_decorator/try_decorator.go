
package main 

import (
    "fmt"
    "math/rand"
)

type A struct {
    V   int 
    K string
}

type B struct {
    R  int 
    J string
}

type Func func() (interface{}, error, bool)

func CallWithRetry(fn Func) (interface{}, error) {
    for {
        result, err, cont := fn()
        if err == nil {
            return result, err
        }
        if !cont {
            return nil, fmt.Errorf("All retires Failed")
        }
    }
}

func Foo(f A) (B, error) {
    b := B{} 
    v := rand.Intn(10)
    if v > 5 {
        b.R = f.V 
        b.J = f.K 
        return b, nil
    } else {
        return b, fmt.Errorf("FooError")
    }
    
}

func main(){
    f := A{K:"abc", V:4}
    attempt := 0
    v, err := CallWithRetry(func() (interface{}, error, bool) {
        fmt.Printf("Calling for %d\n", attempt)
        v, err := Foo(f)
        if err != nil {
            attempt += 1
        }
        return v, err, attempt < 5
    })

    if err == nil {
        fmt.Println(v)
    } else {
        fmt.Println("all retries failed")
    }
}
