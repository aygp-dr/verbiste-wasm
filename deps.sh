#!/bin/bash
# deps.sh - Check for required dependencies for verbiste-wasm project

# Don't exit on error
set +e
echo "Checking dependencies for verbiste-wasm project..."
echo "=================================================="
echo ""

# Colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $1 is installed: $(which $1)"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        return 1
    fi
}

check_emscripten() {
    if check_command emcc; then
        local version
        version=$(emcc --version 2>/dev/null | head -n 1 | tr -d '\n' || echo "unknown")
        echo -e "  ${GREEN}•${NC} emcc version: $version"
        return 0
    else
        # Check if emsdk is cloned
        if [ -d "$HOME/opt/emsdk" ]; then
            echo -e "${YELLOW}!${NC} emsdk found at $HOME/opt/emsdk but not activated"
            echo -e "  ${YELLOW}•${NC} To activate, run:"
            echo -e "    cd $HOME/opt/emsdk"
            echo -e "    ./emsdk install latest"
            echo -e "    ./emsdk activate latest"
            echo -e "    source ./emsdk_env.sh"
            return 2
        fi
        return 1
    fi
}

check_rust_wasm() {
    if check_command wasm-pack; then
        local version
        version=$(wasm-pack --version 2>/dev/null | tr -d '\n' || echo "unknown")
        echo -e "  ${GREEN}•${NC} wasm-pack version: $version"
        return 0
    else
        if check_command cargo; then
            echo -e "${YELLOW}!${NC} Rust is installed but wasm-pack is missing"
            echo -e "  ${YELLOW}•${NC} Install with: cargo install wasm-pack"
            return 2
        fi
        return 1
    fi
}

# Main dependencies
echo "Checking main dependencies:"
echo "-------------------------"

MISSING_MAIN=0

# Required tools
check_command git || ((MISSING_MAIN++))
if check_command python3; then
    # Python3 found
    true
elif check_command python; then
    # Python2 found
    true
else
    # No Python found
    ((MISSING_MAIN++))
fi
check_command make || ((MISSING_MAIN++))

echo ""
echo "Checking WebAssembly toolchain:"
echo "-----------------------------"

MISSING_WASM=0

# Emscripten (C++ to WASM)
check_emscripten
EMSCRIPTEN_STATUS=$?

if [ "$EMSCRIPTEN_STATUS" -ne 0 ]; then
    ((MISSING_WASM++))
    if [ "$EMSCRIPTEN_STATUS" -eq 1 ]; then
        echo -e "  ${YELLOW}•${NC} To install Emscripten:"
        echo -e "    git clone https://github.com/emscripten-core/emsdk.git"
        echo -e "    cd emsdk"
        echo -e "    ./emsdk install latest"
        echo -e "    ./emsdk activate latest"
        echo -e "    source ./emsdk_env.sh"
        echo -e "    # Add to your .bashrc or .zshrc for permanent activation"
    fi
fi

# Rust and wasm-pack (Rust to WASM)
RUST_STATUS=0
if ! check_command rustc || ! check_command cargo; then
    ((MISSING_WASM++))
    RUST_STATUS=1
    echo -e "  ${YELLOW}•${NC} To install Rust:"
    echo -e "    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo -e "    source \$HOME/.cargo/env"
fi

WASM_PACK_STATUS=0
if [ "$RUST_STATUS" -eq 0 ]; then
    check_rust_wasm
    WASM_PACK_STATUS=$?
    if [ "$WASM_PACK_STATUS" -eq 1 ]; then
        ((MISSING_WASM++))
    fi
fi

echo ""
echo "Checking for XML data files:"
echo "--------------------------"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="${SCRIPT_DIR}/resources/verbiste-0.1.49/data"
if [ -d "$RESOURCES_DIR" ]; then
    echo -e "${GREEN}✓${NC} Verbiste XML data found in resources directory"
    if [ -f "$RESOURCES_DIR/verbs-fr.xml" ]; then
        # Count verbs safely
        VERB_FILE="$RESOURCES_DIR/verbs-fr.xml"
        if grep -q '<v i=' "$VERB_FILE" 2>/dev/null; then
            VERB_COUNT=$(grep -c '<v i=' "$VERB_FILE" 2>/dev/null || echo "unknown")
            echo -e "  ${GREEN}•${NC} verbs-fr.xml contains approximately $VERB_COUNT verbs"
        else
            echo -e "  ${YELLOW}•${NC} verbs-fr.xml appears to be empty or invalid"
        fi
    else
        echo -e "  ${YELLOW}•${NC} verbs-fr.xml file not found in resources directory"
    fi
else
    echo -e "${YELLOW}!${NC} Verbiste XML data not found"
    echo -e "  ${YELLOW}•${NC} Run: make resources"
fi

echo ""
echo "Dependencies Summary:"
echo "------------------"
if [ "$MISSING_MAIN" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All essential dependencies are installed"
else
    echo -e "${RED}✗${NC} Missing $MISSING_MAIN essential dependencies"
fi

if [ "$MISSING_WASM" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Full WebAssembly toolchain is available"
elif [ "$EMSCRIPTEN_STATUS" -eq 2 ] || [ "$WASM_PACK_STATUS" -eq 2 ]; then
    echo -e "${YELLOW}!${NC} WebAssembly toolchain partially available (missing activations)"
else
    if [ "$MISSING_WASM" -gt 0 ]; then
        echo -e "${YELLOW}!${NC} WebAssembly toolchain incomplete"
        echo -e "  ${YELLOW}•${NC} Missing tools will be replaced with JavaScript mocks"
        echo -e "  ${YELLOW}•${NC} Project will still build but won't use real WebAssembly"
    fi
fi

echo ""
echo "Next steps:"
echo "----------"
if [ "$MISSING_MAIN" -gt 0 ]; then
    echo -e "${RED}1. Install missing essential dependencies listed above${NC}"
else
    if [ "$MISSING_WASM" -gt 0 ]; then
        echo "1. Install WebAssembly toolchain (optional, mocks will be used otherwise)"
    fi
    echo "2. Build the project:"
    echo "   cd verbiste-wasm && ./build.sh"
    echo "3. Run the demo:"
    echo "   cd verbiste-wasm && ./serve.sh"
    echo "4. Open http://localhost:8000 in your browser"
fi

echo ""
echo "=================================================="