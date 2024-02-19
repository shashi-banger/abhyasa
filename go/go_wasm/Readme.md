
## Copy was_exec.js

```bash
cp "$(go env GOROOT)/misc/wasm/wasm_exec.js" ./public/
```

## Build wasm

```
GOOS=js GOARCH=wasm go build -o  ./public/json.wasm ./wasm
```

## Run server

```bash
cd public
python -m http.server 3080
```

## Open browser

```
http://localhost:3080
```