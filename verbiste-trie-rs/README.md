# Verbiste Trie WASM (Rust Version)

## Prerequisites

- FreeBSD 14.2 or compatible system
- Rust/Cargo (install via `pkg install rust`)
- wasm-pack (install via `cargo install wasm-pack`)

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

Serve the project directory with a web server, for example:

```
cd www
python -m http.server
```

Then navigate to http://localhost:8000/ in your browser.
