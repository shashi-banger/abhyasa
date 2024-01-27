
# Run Benchmark 

```
go test -v -bench . -benchmem
go tool pprof -http=:8080 mem.prof
```