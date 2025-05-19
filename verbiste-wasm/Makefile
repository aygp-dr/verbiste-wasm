CXX = em++
CXXFLAGS = -std=c++17 -O2 
# No need for verbiste-0.1 include since we're implementing our own Trie
EMFLAGS = -s WASM=1 -s MODULARIZE=1 -s EXPORT_ES6=1 -s EXPORTED_RUNTIME_METHODS=['ccall','cwrap'] \
          -s ALLOW_MEMORY_GROWTH=1 -s ASSERTIONS=1 \
          -s "EXPORTED_FUNCTIONS=['_trieInsert','_trieLookup','_trieGetSuggestions','_verbAdapterExtractVerbsFromXML','_verbAdapterGetVerbCount','_verbAdapterGetAllVerbs']" \
          -s "EXPORTED_RUNTIME_METHODS=['stringToUTF8','UTF8ToString']"

SRC_DIR = src
DIST_DIR = dist
TEMPLATE_DIR = templates

SOURCES = $(SRC_DIR)/trie_wrapper.cpp $(SRC_DIR)/french_verb_adapter.cpp

all: directories $(DIST_DIR)/verbiste-trie.js $(DIST_DIR)/index.html $(DIST_DIR)/french-verbs.js

directories:
	mkdir -p $(DIST_DIR)

# Try to compile with Emscripten, fall back to mock if not available
$(DIST_DIR)/verbiste-trie.js: $(SOURCES)
	@if command -v $(CXX) >/dev/null 2>&1; then \
		echo "Compiling with Emscripten..."; \
		$(CXX) $(CXXFLAGS) $(SOURCES) -o $@ $(EMFLAGS); \
		echo "WASM module built successfully!"; \
	else \
		echo "Emscripten not found, using mock implementation..."; \
		cp $(TEMPLATE_DIR)/mock-verbiste-trie.js.template $@; \
		echo "Mock WASM module created."; \
	fi

# Create the french-verbs.js loader module
$(DIST_DIR)/french-verbs.js: $(DIST_DIR)/verbiste-trie.js
	@echo "Creating French verb loader module..."
	@cp $(TEMPLATE_DIR)/french-verbs.js.template $@
	@echo "French verb loader module created."

# Create index.html
$(DIST_DIR)/index.html: $(DIST_DIR)/verbiste-trie.js
	@if [ ! -f $(DIST_DIR)/index.html ]; then \
		echo "Creating HTML interface..."; \
		cp $(TEMPLATE_DIR)/index.html.template $@; \
		echo "HTML interface created."; \
	fi

# Create mock module directly
mock: directories
	@echo "Creating mock implementation..."
	@cp $(TEMPLATE_DIR)/mock-verbiste-trie.js.template $(DIST_DIR)/verbiste-trie.js
	@cp $(TEMPLATE_DIR)/french-verbs.js.template $(DIST_DIR)/french-verbs.js
	@cp $(TEMPLATE_DIR)/index.html.template $(DIST_DIR)/index.html
	@echo "Mock implementation created."

# Clean build artifacts
clean:
	rm -rf $(DIST_DIR)/*

.PHONY: all clean directories mock