# ocr-transform

Convert between Tesseract hOCR and ALTO XML 2.0/2.1 using XSL stylesheets

This project provides an installation path and command line interface for
the stylesheets [developed by @filak](https://github.com/filak/hOCR-to-ALTO).

## Installation

To install system-wide to `/usr/local`:

```sh
sudo make install
```

To install without `sudo` to your home directory:

```sh
make install PREFIX=$HOME/.local
```

If `$HOME/.local/bin` is not in your `PATH`, add this to your shell startup file (e.g. `~/.bashrc` or `~/.zshrc`):

```
export PATH="$HOME/.local/bin $PATH"
```

## Usage

### With an XSLT 2.0 processor

The stylesheets are installed in `$PREFIX/share/ocr-transform/xslt`.

### Command line interface

For now, try `ocr-transform -h` to get an overview.

## License

The XSL stylesheets are licensed [Creative Commons Attribution-ShareAlike 4.0 International.(CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

The XSL transformation is powered by [Saxon HE 9.7](http://saxon.sourceforge.net/#F9.7HE), downloaded
as part of the installation process, licensed under terms of [MPL](https://www.mozilla.org/MPL/).
