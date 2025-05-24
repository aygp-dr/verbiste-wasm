#include <emscripten/bind.h>
#include <string>
#include <vector>
#include <unordered_map>

// Custom implementation based on verbiste Trie.h/Trie.cpp to avoid dependencies

namespace verbiste {

// Simple Trie implementation for WASM, without some advanced features of the original
class Trie {
private:
    struct Node {
        bool is_end_of_word;
        std::unordered_map<char, Node*> children;
        
        Node() : is_end_of_word(false) {}
        ~Node() {
            for (auto& pair : children) {
                delete pair.second;
            }
        }
    };
    
    Node* root;
    
public:
    Trie() : root(new Node()) {}
    
    ~Trie() {
        delete root;
    }
    
    // Insert a word into the trie
    void insert(const std::string& word) {
        Node* current = root;
        
        for (char c : word) {
            if (current->children.find(c) == current->children.end()) {
                current->children[c] = new Node();
            }
            current = current->children[c];
        }
        
        current->is_end_of_word = true;
    }
    
    // Look up a word in the trie
    bool lookup(const std::string& word) {
        Node* node = getNode(word);
        return node != nullptr && node->is_end_of_word;
    }
    
    // Get suggestions for a prefix
    std::vector<std::string> getSuggestions(const std::string& prefix) {
        std::vector<std::string> suggestions;
        Node* node = getNode(prefix);
        
        if (node != nullptr) {
            std::string current_prefix = prefix;
            collectSuggestions(node, current_prefix, suggestions);
        }
        
        return suggestions;
    }
    
private:
    // Helper to get the node for a prefix
    Node* getNode(const std::string& prefix) {
        Node* current = root;
        
        for (char c : prefix) {
            if (current->children.find(c) == current->children.end()) {
                return nullptr;
            }
            current = current->children[c];
        }
        
        return current;
    }
    
    // Recursively collect words with a given prefix
    void collectSuggestions(Node* node, std::string& prefix, std::vector<std::string>& suggestions) {
        if (node->is_end_of_word) {
            suggestions.push_back(prefix);
        }
        
        for (auto& pair : node->children) {
            prefix.push_back(pair.first);
            collectSuggestions(pair.second, prefix, suggestions);
            prefix.pop_back();
        }
    }
};

} // namespace verbiste

// Emscripten bindings
using namespace emscripten;
using namespace verbiste;

EMSCRIPTEN_BINDINGS(trie_module) {
    class_<Trie>("Trie")
        .constructor<>()
        .function("insert", &Trie::insert)
        .function("lookup", &Trie::lookup)
        .function("getSuggestions", &Trie::getSuggestions);
}