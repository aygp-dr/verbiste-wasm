#!/bin/bash
# Make sure wasm-pack is installed
# cargo install wasm-pack

# Build the project
wasm-pack build --target web

# Create www directory if it doesn't exist
mkdir -p www
