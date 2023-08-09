# swift-walk-the-dog

This repository contains a game developed using Swift and WebAssembly, inspired by the excellent book [Game Development with Rust and WebAssembly](https://www.packtpub.com/product/game-development-with-rust-and-webassembly/9781801070973).
The original source code, implemented in Rust, can be found at [this repository](https://github.com/PacktPublishing/Game-Development-with-Rust-and-WebAssembly).

You can play the game online at [swift-walk-the-dog](https://gibachan.github.io/swift-walk-the-dog/), hosted on GitHub Pages.

![sample](https://github.com/gibachan/swift-walk-the-dog/assets/7476703/9ef8dbcd-abca-41c8-b9aa-1ec1c48fa433)

## Usage

### Requirement

- [carton](https://github.com/swiftwasm/carton)

### Development

To start development, execute the `dev.sh` script. This will build the project and launch a local server that hosts the WebAssembly executable along with a corresponding JavaScript entrypoint to load the game.

### Release

To create a release build, run the `release.sh` script. This will build the project and bundle all the assets, including the WebAssembly file, into the `/docs` directory. This directory is configured as the source directory for GitHub Pages hosting.
