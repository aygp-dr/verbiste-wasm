# Verbiste Trie WASM (C++ Version)

## Prerequisites

- FreeBSD 14.2 or compatible system
- Emscripten (install via `pkg install emscripten`)
- The fr-verbiste package (install via `pkg install fr-verbiste`)

## Building

1. Make the build script executable:
   ```
   chmod +x build.sh
   ```

2. Run the build script:
   ```
   ./build.sh
   ```

## Running

Serve the `dist` directory with a web server, for example:

```
cd dist
python -m http.server
```

Then navigate to http://localhost:8000/ in your browser.
