use std::collections::HashMap;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub struct TrieNode {
    #[wasm_bindgen(skip)]
    children: HashMap<char, TrieNode>,
    is_end_of_word: bool,
}

#[wasm_bindgen]
impl TrieNode {
    #[wasm_bindgen(constructor)]
    pub fn new() -> TrieNode {
        TrieNode {
            children: HashMap::new(),
            is_end_of_word: false,
        }
    }
}

#[wasm_bindgen]
pub struct Trie {
    #[wasm_bindgen(skip)]
    root: TrieNode,
}

#[wasm_bindgen]
impl Trie {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Trie {
        Trie {
            root: TrieNode::new(),
        }
    }

    pub fn insert(&mut self, word: &str) {
        let mut current = &mut self.root;
        
        for c in word.chars() {
            current = current.children.entry(c).or_insert(TrieNode::new());
        }
        
        current.is_end_of_word = true;
    }

    pub fn lookup(&self, word: &str) -> bool {
        let mut current = &self.root;
        
        for c in word.chars() {
            match current.children.get(&c) {
                Some(node) => current = node,
                None => return false,
            }
        }
        
        current.is_end_of_word
    }

    pub fn get_suggestions(&self, prefix: &str) -> Box<[JsValue]> {
        let mut suggestions = Vec::new();
        let mut current = &self.root;
        
        // Navigate to the end of the prefix
        for c in prefix.chars() {
            match current.children.get(&c) {
                Some(node) => current = node,
                None => return suggestions.into_boxed_slice(),
            }
        }
        
        // Find all words with this prefix
        let mut prefix_chars: Vec<char> = prefix.chars().collect();
        self.collect_suggestions(current, &mut prefix_chars, &mut suggestions);
        
        suggestions.into_boxed_slice()
    }

    fn collect_suggestions(&self, node: &TrieNode, prefix: &mut Vec<char>, suggestions: &mut Vec<JsValue>) {
        if node.is_end_of_word {
            let word: String = prefix.iter().collect();
            suggestions.push(JsValue::from_str(&word));
        }
        
        for (&c, child) in &node.children {
            prefix.push(c);
            self.collect_suggestions(child, prefix, suggestions);
            prefix.pop();
        }
    }
}
