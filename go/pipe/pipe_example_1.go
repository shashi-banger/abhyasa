
package main

import (
    "syscall"
    "os"
    "io"
    "time"
    "fmt"
)

var pipename = "/tmp/sb"

func writePipe(syncchan chan int) {
    fmt.Printf("In writePipe\n")
    file, err := os.OpenFile(pipename, os.O_CREATE | os.O_RDWR, os.ModeNamedPipe)
    fmt.Printf("In openfile for O_CREATE %v\n", err)
    if err != nil {
        return
    }
    syncchan <- 1

    for i := 0; i < 10; i++ {
        fmt.Printf("Writing %v to pipe\n", i)
        file.Write([]byte{0, 1, 0, byte(i)})
        time.Sleep(time.Second)
    }

    file.Close()
}

func readPipe(syncchan, exitchan chan int) {
    fmt.Printf("In readPipe\n")
    file, err := os.OpenFile(pipename, os.O_RDONLY, os.ModeNamedPipe)
    fmt.Printf("err %v\n", err)
    <- syncchan
    barr := make([]byte, 16)
    n := 0
    for {
        fmt.Printf("file.Read\n")
        n, err = file.Read(barr)
        fmt.Printf("file.Read %v %v\n", n, err)
        if err == io.EOF {
            break
        }
        fmt.Printf("Received %v bytes, %v\n", n, barr)
    }
    exitchan <- 1
}

func main() {
    os.Remove(pipename)
    syscall.Mkfifo(pipename, 0666)
    syncchan := make(chan int)
    exitchan := make(chan int)
    go writePipe(syncchan)
    go readPipe(syncchan, exitchan)
    <- exitchan
}
