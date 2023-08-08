# swift-walk-the-dog

Swift game development exercise, referring to this great book https://www.oreilly.co.jp/books/9784814400393/ .
You can find the original source code written in Rust at https://github.com/PacktPublishing/Game-Development-with-Rust-and-WebAssembly .

## Requirement

- [carton](https://github.com/swiftwasm/carton)

## Usage

### development

```
% ./dev.sh
```

Builds the project and runs local server to host WebAssembly executable and a corresponding JavaScript entrypoint that loads it.

### release

```
% ./release.sh
```

All assets including wasm file will be build in `/doc` directory where is configured as GitHub Pages source directory.
