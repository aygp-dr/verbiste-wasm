#!/bin/bash
set -e

# Ensure we are in the right directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Set up directories
RESOURCES_DIR="../resources/verbiste-0.1.49/data"
DATA_DIR="./dist/data"
mkdir -p "$DATA_DIR"

# Copy XML files for verbs and conjugations
if [ -d "$RESOURCES_DIR" ]; then
  cp "$RESOURCES_DIR"/*.xml "$DATA_DIR/"
  echo "Copied XML data files to $DATA_DIR"
fi

# Check if Emscripten is available
if command -v em++ >/dev/null 2>&1; then
  # Source emscripten environment if needed
  # source /usr/local/share/emscripten/emsdk_env.sh
  echo "Emscripten found. Building with real WebAssembly..."
  make
else
  echo "Emscripten not found. Using mock implementation..."
  make mock
fi

echo "Build complete! Use ./serve.sh to run the demo."
