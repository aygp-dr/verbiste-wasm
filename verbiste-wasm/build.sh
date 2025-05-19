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

# Use EMSDK_PATH environment variable if set
if [ -n "$EMSDK_PATH" ] && [ -f "$EMSDK_PATH/emsdk_env.sh" ]; then
  echo "Using Emscripten SDK at $EMSDK_PATH"
  # Source the emsdk environment
  source "$EMSDK_PATH/emsdk_env.sh"
  
  # Check if emscripten is activated properly
  if [ -x "$EMSDK_PATH/upstream/emscripten/em++" ]; then
    echo "Found em++ in $EMSDK_PATH/upstream/emscripten/"
    export PATH="$EMSDK_PATH/upstream/emscripten:$PATH"
  elif [ -x "$EMSDK_PATH/upstream/bin/em++" ]; then
    echo "Found em++ in $EMSDK_PATH/upstream/bin/"
    export PATH="$EMSDK_PATH/upstream/bin:$PATH"
  fi
fi

# Check if Emscripten is available with more debugging
echo "Checking for em++ in PATH..."
which em++ || echo "em++ not found in PATH"

# Skip the test for now and use mock implementation
if command -v em++ >/dev/null 2>&1; then
  echo "Emscripten found at $(which em++), but using mock implementation for prototype..."
  # In a real environment, we would want to fully set up Emscripten with proper config
  make mock
else
  echo "Emscripten not found. Using mock implementation..."
  make mock
fi

echo "Build complete! Use ./serve.sh to run the demo."
