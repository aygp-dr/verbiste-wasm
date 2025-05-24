# Verbiste WASM

[![GitHub issues](https://img.shields.io/github/issues/aygp-dr/verbiste-wasm)](https://github.com/aygp-dr/verbiste-wasm/issues)
[![License](https://img.shields.io/github/license/aygp-dr/verbiste-wasm)](https://github.com/aygp-dr/verbiste-wasm/blob/main/LICENSE)

French conjugation library compiled to WebAssembly for browser-based verb conjugation.

## Project Overview

Verbiste WASM is a WebAssembly port of the Verbiste French conjugation library, enabling fast and accurate French verb conjugation directly in the browser with no server required.

### Key Features

- Fast conjugation of French verbs through WebAssembly
- Support for all French tenses and moods
- Small footprint for quick loading in browser applications
- Easy integration with JavaScript and modern web frameworks

## Getting Started

The project consists of two main components:
1. `verbiste-trie-rs`: Rust implementation of the conjugation engine
2. `verbiste-wasm`: C++ wrapper and WASM build toolchain

### Prerequisites

- Rust toolchain (with wasm32 target)
- Emscripten
- Node.js (for testing)

### Building

Follow the setup instructions in SETUP.org:

```bash
emacs --batch --eval "(require 'org)" --eval "(org-babel-tangle-file \"SETUP.org\")"
./make_executable.sh
```

## Usage

Basic usage example:

```javascript
import { conjugate } from 'verbiste-wasm';

const results = conjugate('parler', 'présent', 'indicatif');
console.log(results);
// Output: ['je parle', 'tu parles', 'il/elle parle', 'nous parlons', 'vous parlez', 'ils/elles parlent']
```

## Roadmap

See the [open issues](https://github.com/aygp-dr/verbiste-wasm/issues) for a list of proposed features and known issues.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Based on the [Verbiste](https://perso.b2b2c.ca/~sarrazip/dev/verbiste.html) library by Pierre Sarrazin
- French conjugation data from [Lefff](http://alpage.inria.fr/~sagot/lefff.html)