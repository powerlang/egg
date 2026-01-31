# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Egg is a MIT-licensed implementation of a Smalltalk-80 derived environment. It's a module-based Smalltalk system that supports multiple runtime platforms (JS, C++, Pharo) and uses image segments for fast module loading.

## Architecture

### Core Components

- **modules/**: Smalltalk source code organized by module (Kernel, Compiler, LMR, etc.)
- **runtime/**: Platform-specific VM implementations
  - **runtime/pharo/**: Bootstrap and development platform - main platform for kernel development
  - **runtime/js/**: JavaScript VM implementation for browser/Node.js
  - **runtime/cpp/**: Native C++ VM implementation
- **image-segments/**: Generated binary module files for fast loading (`.json` for JS, `.ems` for native)
- **docs/**: Sphinx documentation

### Key Concepts

- **Module System**: Each module has its own namespace, no global Smalltalk dictionary
- **Image Segments**: Binary format for fast module loading without compilation. Generated from Pharo using EggBuilder
- **Dynamic Binding**: Identifiers resolved at runtime with caching (supports `#doesNotKnow:` like `#doesNotUnderstand:`)
- **Multi-Platform**: Same Smalltalk code runs on all supported VMs
- **LMR**: Live Metacircular Runtime - a Smalltalk-in-Smalltalk VM implementation

## Development Commands

### Building Platforms

```bash
make pharo    # Bootstrap platform (creates egg.image)
make js       # JavaScript VM
make cpp      # Native C++ VM (uses Conan + CMake)
make clean    # Clean all runtimes
```

### Testing

```bash
make test     # Run SUnit tests (requires Pharo runtime)
make test-ci  # Run tests in CI (outputs JUnit XML to test-reports/)
```

### Pharo Development Environment

```bash
cd runtime/pharo
make all           # Create Pharo image
./pharo-ui egg.image   # Open GUI for development
```

### Image Segment Generation

```bash
cd runtime/pharo
make core-js-segments      # Generate .json segments for JS
make core-native-segments  # Generate .ems segments for C++/native
```

### JavaScript Development

```bash
cd runtime/js
make all              # Builds interpreter and core segments
make example-server   # Builds example server with all dependencies
```

### C++ Development

```bash
cd runtime/cpp
make all              # Uses Conan and CMake
make core-segments    # Generate image segments for native platform
```

### Webside (Web IDE)

```bash
cd runtime/pharo
make webside    # Starts web server on port 9002
```

## Commit Message Convention

Commit messages must start with a tag indicating the affected area:

```
<tag>: <short description>

Examples:
kernel: fix method lookup for proxies
bootstrap: add support for new primitive
js: optimize message send
compiler: handle edge case in parser
```

## Code Style

See CONTRIBUTING.md for full details. Key rules:

- **Short names**: Single-word temps, usage-primary naming (`done` not `tasksThatHaveBeenDone`)
- **No comments**: Except public API headers. Refactor instead of commenting
- **No nested loops**: Factor into separate methods
- **No keyword-in-keyword**: Use temps instead of `self foo: (self bar: x)`
- **Autoformatted**: All code is autoformatted
- **Simplicity over performance**: Let the runtime optimize

## Key Files

- `modules/Kernel/`: Core Smalltalk classes (Object, Class, etc.)
- `modules/Compiler/`: Smalltalk compiler and parser
- `modules/LMR/`: Live Metacircular Runtime
- `runtime/pharo/BaselineOfPowerlang/`: Metacello baseline (groups: `base`, `devel`, `powerlangjs`)
- `runtime/pharo/Powerlang-Tests/`: Runtime tests