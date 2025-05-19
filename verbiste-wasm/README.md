# Verbiste-WASM (C++ Implementation)

This directory contains the C++ WebAssembly implementation of the Verbiste French verb dictionary and conjugation system.

## Current Status

This is an MVP (Minimum Viable Product) implementation with the following features:
- Custom Trie data structure for efficient string lookup
- Simple French verb dictionary loaded from XML files
- Auto-suggestions for verb prefixes
- Simple web interface for searching French verbs

## Prerequisites

- Emscripten (for building from source, install via `pkg install emscripten`)
- Python (for running the local development server)

## Quick Start

There are two ways to build and run the project:

### Option 1: Using the mock implementation (no Emscripten required)

If Emscripten is not available, the build script will automatically create a JavaScript mock implementation:

```bash
# Ensure build script is executable
chmod +x build.sh serve.sh

# Build the project with JavaScript mock implementation
./build.sh

# Serve the files with a local web server
./serve.sh
```

Then open http://localhost:8000 in your browser.

### Option 2: Building with Emscripten

If you have Emscripten installed, the build script will compile the C++ code to WebAssembly:

```bash
# Install Emscripten if not already installed
# pkg install emscripten   # For FreeBSD
# Or follow Emscripten installation instructions for your platform

# Build the project with real WebAssembly
./build.sh

# Serve the files
./serve.sh
```

### Building directly with Make

You can also use Make directly:

```bash
# Build with Emscripten (if available) or fall back to mock
make

# Force using the mock implementation
make mock

# Clean build artifacts
make clean
```

## Architecture

The implementation consists of:

1. `trie_wrapper.cpp` - A custom Trie implementation for efficient string lookup
2. `french_verb_adapter.cpp` - An adapter to load and parse French verb data
3. `verbiste-trie.js` - The compiled WebAssembly module (and JavaScript glue code)
4. `french-verbs.js` - A JavaScript module to load verb data
5. `index.html` - A simple web interface for searching and auto-suggesting verbs

## Data Files

The implementation uses the following data files:
- `data/verbs-fr.xml` - List of French verbs and their templates
- `data/conjugation-fr.xml` - Conjugation templates (not yet implemented)

## Future Work

- Implement full conjugation functionality
- Add deconjugation (identify infinitive from conjugated form)
- Improve XML parsing
- Optimize WebAssembly file size
- Add support for irregular verbs

## License

This project is licensed under the same terms as the original Verbiste library (GPL).
