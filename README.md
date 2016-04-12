# ocr-schemas

Validate and transform between OCR file formats (hOCR, ALTO, PAGE)

<!-- vim :GenToc GFM -->
* [Installation](#installation)
* [Usage](#usage)
	* [With an XSLT 2.0 processor](#with-an-xslt-20-processor)
	* [Command line interface](#command-line-interface)
* [License](#license)

[![Build Status](https://travis-ci.org/UB-Mannheim/ocr-transform.svg?branch=master)](https://travis-ci.org/UB-Mannheim/ocr-transform)

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

## Transformation

### Command line interface

For now, try `ocr-transform -h` to get an overview.

### With an XSLT 2.0 processor

The stylesheets are installed in `$PREFIX/share/ocr-transform/xslt` and can be
used directly in your scripts and software. You will need to use an XSLT 2.0
capable stylesheet transformer.

## License

The XSL stylesheets are licensed [Creative Commons Attribution-ShareAlike 4.0 International.(CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

The XSL transformation is powered by [Saxon HE 9.7](http://saxon.sourceforge.net/#F9.7HE), downloaded
as part of the installation process, licensed under terms of [MPL](https://www.mozilla.org/MPL/).
