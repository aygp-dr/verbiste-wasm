#include <emscripten/bind.h>
#include "/usr/local/include/verbiste-0.1/verbiste/Trie.h"

using namespace emscripten;
using namespace verbiste;

EMSCRIPTEN_BINDINGS(trie_module) {
    class_<Trie>("Trie")
        .constructor<>()
        .function("insert", &Trie::insert)
        .function("lookup", &Trie::lookup)
        .function("getSuggestions", &Trie::getSuggestions);
}
