// French verb loader module
export async function loadVerbs(VerbisteModule) {
    try {
        const module = await VerbisteModule();
        const adapter = new module.FrenchVerbAdapter();
        const trie = new module.Trie();
        
        // Create a simple list of common French verbs
        const commonVerbs = [
            "parler", "manger", "finir", "voir", "être", "avoir",
            "dire", "faire", "aller", "prendre", "venir", "savoir",
            "falloir", "vouloir", "pouvoir", "croire", "mettre", "devoir",
            "lire", "écrire", "comprendre", "connaître", "partir", "sortir",
            "entrer", "monter", "descendre", "arriver", "attendre", "donner"
        ];
        
        // Try to load from data file if available
        let verbsLoaded = false;
        
        try {
            const response = await fetch("./data/verbs-fr.xml");
            if (response.ok) {
                const xmlContent = await response.text();
                verbsLoaded = adapter.extractVerbsFromXML(xmlContent);
                console.log(`Loaded ${adapter.getVerbCount()} verbs from XML`);
            }
        } catch (error) {
            console.warn("Could not load verbs from XML file:", error);
        }
        
        // Fall back to common verbs if nothing loaded
        if (!verbsLoaded || adapter.getVerbCount() === 0) {
            commonVerbs.forEach(verb => trie.insert(verb));
            console.log(`Loaded ${commonVerbs.length} common verbs`);
        } else {
            // Add all verbs from adapter to trie
            const allVerbs = adapter.getAllVerbs();
            allVerbs.forEach(verb => trie.insert(verb));
        }
        
        return {
            module,
            trie,
            adapter
        };
    } catch (error) {
        console.error("Error initializing Verbiste:", error);
        throw error;
    }
}