#include <emscripten/bind.h>
#include <string>
#include <vector>
#include <unordered_map>
#include <fstream>
#include <iostream>

namespace verbiste {

// Simple adapter to load French verb data
class FrenchVerbAdapter {
private:
    std::vector<std::string> verbs;
    
public:
    FrenchVerbAdapter() {}
    
    // Load verbs from a file (simple text format)
    bool loadVerbsFromFile(const std::string& filename) {
        std::ifstream file(filename);
        if (!file.is_open()) {
            std::cerr << "Failed to open file: " << filename << std::endl;
            return false;
        }
        
        std::string line;
        while (std::getline(file, line)) {
            // Skip empty lines and comments
            if (line.empty() || line[0] == '#') continue;
            
            // Trim whitespace
            line.erase(0, line.find_first_not_of(" \t"));
            line.erase(line.find_last_not_of(" \t") + 1);
            
            if (!line.empty()) {
                verbs.push_back(line);
            }
        }
        
        return true;
    }
    
    // Extract verbs from XML data (simplified for now)
    bool extractVerbsFromXML(const std::string& xmlContent) {
        // This is a simplified parser for the verbiste XML format
        // In a real implementation, we would use a proper XML parser
        
        size_t pos = 0;
        const std::string startTag = "<v i=\"";
        const std::string endTag = "\">";
        
        while ((pos = xmlContent.find(startTag, pos)) != std::string::npos) {
            pos += startTag.length();
            size_t endPos = xmlContent.find(endTag, pos);
            
            if (endPos != std::string::npos) {
                std::string verb = xmlContent.substr(pos, endPos - pos);
                if (!verb.empty()) {
                    verbs.push_back(verb);
                }
                pos = endPos + endTag.length();
            } else {
                break;
            }
        }
        
        return !verbs.empty();
    }
    
    // Get all loaded verbs
    std::vector<std::string> getAllVerbs() const {
        return verbs;
    }
    
    // Get verbs that start with a prefix
    std::vector<std::string> getVerbsWithPrefix(const std::string& prefix) const {
        std::vector<std::string> matches;
        
        for (const auto& verb : verbs) {
            if (verb.compare(0, prefix.length(), prefix) == 0) {
                matches.push_back(verb);
            }
        }
        
        return matches;
    }
    
    // Check if a verb exists
    bool verbExists(const std::string& verb) const {
        for (const auto& v : verbs) {
            if (v == verb) return true;
        }
        return false;
    }
    
    // Get verb count
    size_t getVerbCount() const {
        return verbs.size();
    }
};

} // namespace verbiste

// Emscripten bindings
using namespace emscripten;
using namespace verbiste;

EMSCRIPTEN_BINDINGS(french_verb_adapter_module) {
    class_<FrenchVerbAdapter>("FrenchVerbAdapter")
        .constructor<>()
        .function("loadVerbsFromFile", &FrenchVerbAdapter::loadVerbsFromFile)
        .function("extractVerbsFromXML", &FrenchVerbAdapter::extractVerbsFromXML)
        .function("getAllVerbs", &FrenchVerbAdapter::getAllVerbs)
        .function("getVerbsWithPrefix", &FrenchVerbAdapter::getVerbsWithPrefix)
        .function("verbExists", &FrenchVerbAdapter::verbExists)
        .function("getVerbCount", &FrenchVerbAdapter::getVerbCount);
}