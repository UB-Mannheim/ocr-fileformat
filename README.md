# ocr-transform

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

### With an XSLT 2.0 processor

The stylesheets are installed in `$PREFIX/share/ocr-transform/xslt`.

### Command line interface

For example, you can transform an ALTO XML to a hOCR file with:

```sh
ocr-transform alto hocr sample.xml sample.hocr
```

Or convert from ALTO XML (version 2.1) to hOCR with:

```sh
ocr-transform alto2.1 hocr sample.alto sample.hocr
```

You can also pass arguments directly to the Saxon CLI by passing them after a double dash (`--`). For example, to set the `foo` parameter to `bar`:

```sh
ocr-transform alto hocr sample.xml sample.hocr -- foo=bar
```

Try `ocr-transform -h` to get an overview:

```
Usage: ocr-transform [-dl] <input-fmt> <output-fmt> [<input> [<output>]] [-- <saxon_opts>]
Input formats:
- 'alto'
- 'hocr'
Output formats:
- 'alto2.0'
- 'alto2.1'
- 'hocr'
Saxon-HE 9.7.0.4J from Saxonica
Java version 1.7.0_95
No source file name
Usage: see http://www.saxonica.com/html/documentation/using-xsl/commandline.html
Format: net.sf.saxon.Transform options params
Options available: -? -a -catalog -config -cr -diag -dtd -ea -expand -explain -export -ext -im -init -it -l -license -m -nogo -now -o -opt -or -outval -p -pack -quit -r -repeat -s -sa -scmin -strip -t -T -threads -TJ -TP -traceout -tree -u -val -versionmsg -warnings -x -xi -xmlversion -xsd -xsdversion -xsiloc -xsl -xsltversion -y
Use -XYZ:? for details of option XYZ
Params: 
param=value           Set stylesheet string parameter
+param=filename       Set stylesheet document parameter
?param=expression     Set stylesheet parameter using XPath
!param=value          Set serialization parameter
```

## License

The XSL stylesheets are licensed [Creative Commons Attribution-ShareAlike 4.0 International.(CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

The XSL transformation is powered by [Saxon HE 9.7](http://saxon.sourceforge.net/#F9.7HE), downloaded
as part of the installation process, licensed under terms of [MPL](https://www.mozilla.org/MPL/).
