#!/bin/bash

# Get directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Build first if needed
if [ ! -f dist/verbiste-trie.js ]; then
  echo "Building project first..."
  ./build.sh
fi

# Serve the dist directory
echo "Starting web server on http://localhost:8000"
echo "Press Ctrl+C to stop"

# Try to use python3 http.server, fallback to python2 SimpleHTTPServer
if command -v python3 &> /dev/null; then
  cd dist && python3 -m http.server
elif command -v python &> /dev/null; then
  cd dist && python -m SimpleHTTPServer
else
  echo "Error: Python is not installed. Please install Python to use this script."
  exit 1
fi