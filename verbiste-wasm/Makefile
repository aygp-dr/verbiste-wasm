CXX = em++
CXXFLAGS = -std=c++11 -O2
INCLUDE = -I/usr/local/include/verbiste-0.1
LDFLAGS = -L/usr/local/lib -lverbiste-0.1
EMFLAGS = -s WASM=1 -s MODULARIZE=1 -s EXPORT_ES6=1 -s EXPORTED_RUNTIME_METHODS=['ccall','cwrap']

SRC_DIR = src
DIST_DIR = dist

all: $(DIST_DIR)/verbiste-trie.js

$(DIST_DIR)/verbiste-trie.js: $(SRC_DIR)/trie_wrapper.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE) $< -o $@ $(LDFLAGS) $(EMFLAGS)

clean:
	rm -f $(DIST_DIR)/*

.PHONY: all clean
