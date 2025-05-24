# Verbiste-WASM Main Makefile
# This makefile coordinates building both C++ and Rust versions of the Verbiste WASM library

VERBISTE_VERSION = 0.1.49
VERBISTE_ARCHIVE = verbiste_$(VERBISTE_VERSION).orig.tar.gz
VERBISTE_URL = https://cse-web-mirror-prd-01.cse.umn.edu/ubuntu/pool/universe/v/verbiste/$(VERBISTE_ARCHIVE)

.PHONY: all clean setup build-cpp build-rust resources

all: setup build-cpp build-rust

setup:
	@echo "Setting up project..."
	./verbiste-wasm/setup.sh
	./verbiste-trie-rs/setup.sh
	@echo "Setup complete."

build-cpp:
	@echo "Building C++ version..."
	cd verbiste-wasm && ./build.sh
	@echo "C++ build complete."

build-rust:
	@echo "Building Rust version..."
	cd verbiste-trie-rs && ./build.sh
	@echo "Rust build complete."

clean:
	@echo "Cleaning all builds..."
	cd verbiste-wasm && make clean
	cd verbiste-trie-rs && cargo clean
	@echo "Clean complete."

# Download verbiste source archive
resources/$(VERBISTE_ARCHIVE):
	@echo "Downloading Verbiste source archive..."
	@mkdir -p resources
	@wget -q -O resources/$(VERBISTE_ARCHIVE) $(VERBISTE_URL)
	@echo "Downloaded Verbiste source archive to resources/$(VERBISTE_ARCHIVE)"

resources: resources/$(VERBISTE_ARCHIVE)

# Dependencies
deps:
	@echo "Installing dependencies..."
	# Check if we're on FreeBSD
	@if [ -f /usr/bin/freebsd-version ]; then \
		sudo pkg install -y emscripten fr-verbiste rust; \
	else \
		echo "This might not be a FreeBSD system. Please install manually:"; \
		echo "- Emscripten (https://emscripten.org/docs/getting_started/downloads.html)"; \
		echo "- fr-verbiste (or equivalent for your system)"; \
		echo "- Rust (https://www.rust-lang.org/tools/install)"; \
	fi
	# Install wasm-pack for Rust
	cargo install wasm-pack
	@echo "Dependencies installed."