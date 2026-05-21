
# Requirements
Designed for Linux, but should run on Mac (not tested). Will not work on Windows. 

Tested on a PicoScope 2204, but should work on any 2000-series PicoScope.

- [PicoScope drivers](https://www.picotech.com/downloads/linux)
- Recent C compiler
- [Cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html)

# Building
```bash
cargo build --release
```

# Running
```bash
cargo run --release -- <desired sample rate>
```

___

`--release` flag is optional, but recommended for a faster resulting binary. Sample rate is also optional. Software will attempt to find the closest sample rate supported by the PicoScope. 



