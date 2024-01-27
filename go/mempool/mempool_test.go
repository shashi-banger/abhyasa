package main

import (
	"bytes"
	"fmt"
	"os"
	"runtime"
	"runtime/pprof"
	"sync"
	"testing"
)

type MemPool struct {
	m       sync.Mutex
	BufPool *sync.Pool
	cond    *sync.Cond
}

func NewMemPool(nb int) *MemPool {
	mp := &MemPool{}
	mp.BufPool = &sync.Pool{}
	for i := 0; i < nb; i++ {
		mp.BufPool.Put(new(bytes.Buffer))
	}
	mp.cond = sync.NewCond(&mp.m)
	return mp
}

func (mp *MemPool) GetBuf() *bytes.Buffer {
	mp.m.Lock()
	buf := mp.BufPool.Get()
	for {
		if buf == nil {
			mp.cond.Wait()
		} else {
			break
		}
		buf = mp.BufPool.Get()
	}
	mp.m.Unlock()
	return buf.(*bytes.Buffer)
}

func (mp *MemPool) PutBuf(buf *bytes.Buffer) {
	mp.m.Lock()
	mp.BufPool.Put(buf)
	mp.cond.Signal()
	mp.m.Unlock()
}

func BenchmarkMempool(b *testing.B) {
	var m1, m2 runtime.MemStats
	nb := 10
	runtime.GC()
	mp := NewMemPool(nb)
	allBufs := []*bytes.Buffer{}
	s := "hello"

	runtime.ReadMemStats(&m1)
	for i := 0; i < 3000; i++ {
		buf := mp.GetBuf()
		if i >= (nb - 1) {
			//fmt.Println(i, " buf is nil")
			mp.PutBuf(allBufs[0])
			allBufs = allBufs[1:]
		}
		allBufs = append(allBufs, buf)
		buf.Reset()
		//fmt.Println(buf1.Cap(), "buf is not nil")
		buf.WriteString(s)
		//fmt.Println(buf1.String())
		//mp.BufPool.Put(buf)
	}
	runtime.ReadMemStats(&m2)
	fmt.Println("total:", m2.TotalAlloc-m1.TotalAlloc)
	fmt.Println("mallocs:", m2.Mallocs-m1.Mallocs)
}

func TestParallelUsage(t *testing.T) {
	memProfileFile, err := os.Create("mem.prof")
	if err != nil {
		panic(err)
	}
	defer memProfileFile.Close()
	var wg sync.WaitGroup
	var m1, m2 runtime.MemStats
	nb := 10
	runtime.GC()
	mp := NewMemPool(nb)
	allBufs := []*bytes.Buffer{}
	s := "hello"

	runtime.ReadMemStats(&m1)
	for i := 0; i < 100000; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			buf := mp.GetBuf()
			allBufs = append(allBufs, buf)
			buf.Reset()
			//fmt.Println(buf1.Cap(), "buf is not nil")
			buf.WriteString(s)
			//time.Sleep(time.Millisecond * 10)
			mp.PutBuf(buf)
			//fmt.Println(buf1.String())
			//mp.BufPool.Put(buf)
		}()
	}
	wg.Wait()
	runtime.ReadMemStats(&m2)
	fmt.Println("total:", m2.TotalAlloc-m1.TotalAlloc)
	fmt.Println("mallocs:", m2.Mallocs-m1.Mallocs)
	if err := pprof.WriteHeapProfile(memProfileFile); err != nil {
		panic(err)
	}
}
