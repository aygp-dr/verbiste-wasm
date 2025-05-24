// Mock WASM module for demonstration
export default function() {
  return new Promise((resolve) => {
    console.log("Loading mock Verbiste WASM module...");
    
    // Simulate module loading delay
    setTimeout(() => {
      const module = {
        // Trie class implementation
        Trie: class {
          constructor() {
            this.words = new Set();
          }
          
          insert(word) {
            this.words.add(word);
            return true;
          }
          
          lookup(word) {
            return this.words.has(word);
          }
          
          getSuggestions(prefix) {
            return Array.from(this.words).filter(word => 
              word.startsWith(prefix)
            );
          }
        },
        
        // French verb adapter implementation
        FrenchVerbAdapter: class {
          constructor() {
            this.verbs = [];
          }
          
          extractVerbsFromXML(content) {
            // Simple XML parsing logic
            const verbMatches = content.match(/<v i="([^"]+)"/g) || [];
            this.verbs = verbMatches.map(match => {
              const verbMatch = match.match(/<v i="([^"]+)"/);
              return verbMatch ? verbMatch[1] : null;
            }).filter(Boolean);
            
            return this.verbs.length > 0;
          }
          
          loadVerbsFromFile() {
            // Not implemented in mock
            return false;
          }
          
          getAllVerbs() {
            return this.verbs;
          }
          
          getVerbsWithPrefix(prefix) {
            return this.verbs.filter(verb => verb.startsWith(prefix));
          }
          
          verbExists(verb) {
            return this.verbs.includes(verb);
          }
          
          getVerbCount() {
            return this.verbs.length;
          }
        }
      };
      
      console.log("Mock Verbiste WASM module loaded");
      resolve(module);
    }, 500);
  });
}