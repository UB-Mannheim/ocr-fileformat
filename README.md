# ocr-fileformat

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/46847fb2bf764f77bd8feb35b003120a)](https://www.codacy.com/app/UB-Mannheim/ocr-fileformat?utm_source=github.com&utm_medium=referral&utm_content=UB-Mannheim/ocr-fileformat&utm_campaign=badger)
[![Build Status](https://travis-ci.org/UB-Mannheim/ocr-fileformat.svg?branch=master)](https://travis-ci.org/UB-Mannheim/ocr-fileformat)
[![GitHub release](https://img.shields.io/github/release/UB-Mannheim/ocr-fileformat.svg?maxAge=3600)](https://github.com/UB-Mannheim/ocr-fileformat/releases)
[![ocr-fileformat Docker build](https://img.shields.io/docker/automated/ubma/ocr-fileformat.svg?maxAge=2592000?style=plastic)](https://hub.docker.com/r/ubma/ocr-fileformat)

Validate and transform between OCR file formats (hOCR, ALTO, PAGE, FineReader)

![Screenshot GUI](https://raw.githubusercontent.com/UB-Mannheim/ocr-fileformat/master/screenshot.png)

<!-- BEGIN-MARKDOWN-TOC -->
* [Installation](#installation)
	* [Docker](#docker)
	* [System-wide](#system-wide)
* [Usage](#usage)
	* [CLI](#cli)
	* [GUI](#gui)
	* [API](#api)
* [Transformation](#transformation)
	* [Transformation CLI](#transformation-cli)
	* [Transformation GUI](#transformation-gui)
	* [Transformation API](#transformation-api)
	* [Supported Transformations](#supported-transformations)
* [Validation](#validation)
	* [Validation CLI](#validation-cli)
	* [Validation GUI](#validation-gui)
	* [Validation API](#validation-api)
	* [Supported Validation Formats](#supported-validation-formats)
* [License](#license)

<!-- END-MARKDOWN-TOC -->

## Installation

### Docker

You can run the [command line scripts](#cli) and [web interface](#gui) as a
[Docker container](https://hub.docker.com/r/ubma/ocr-fileformat), you only need
Docker installed.

To start the web interface on [http://localhost:8080](http://localhost:8080):

```sh
docker run --rm -it -p 8080:8080 ubma/ocr-fileformat
```

To run the command line scripts, mount the directory containing your input
files into the container's `/data` directory:

```sh
docker run --rm -it -v "$PWD":/data ubma/ocr-fileformat ocr-transform alto2.0 hocr somefile.alto
```

### System-wide

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

The web application has a PHP backed. You can deploy it on any PHP-capable
server by copying the [`web`](./web) folder somewhere below the document root
of your server, e.g. `/var/www/html` for Apache on Debian/Ubuntu:

```
sudo -u www-data cp -r web /var/www/html/ocr-fileformat
```

In this example the GUI would be available under [http://localhost/ocr-fileformat/](http://localhost/ocr-fileformat/).

## Usage

The project offers two functionalities, which can be accessd via a command line
script (CLI), using a web interface (GUI) or in you own tools (API)

### CLI

* [`ocr-transform`](./blob/master/bin/ocr-transform.sh): Transformation of OCR output between OCR formats
* [`ocr-validate`](./blob/master/bin/ocr-validate.sh): Validation of OCR output against OCR format schemas

### GUI

The web interface is for testing validation and transformations. You can upload
a file or select an input file by URL.

### API

* [`$PREFIX/share/ocr-fileformat/xslt`](./xslt) - XSLT stylesheets
* [`$PREFIX/share/ocr-fileformat/xsd`](./xsd) - XSD schemas
* [`$PREFIX/share/ocr-fileformat/script/transform`](./script/transform) - Transformation scripts
* [`$PREFIX/share/ocr-fileformat/script/validate`](./script/validate) - Validation scripts

## Transformation

### Transformation CLI

```
Usage: ocr-transform [-dl] <input-fmt> <output-fmt> [<input> [<output>]] [-- <saxon_opts>]
```

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

<!-- BEGIN-EVAL echo '<pre>';./bin/ocr-transform.sh -h 2>&1;echo '</pre>'  -->
<pre>
Usage: ocr-transform.sh [-dhL] <from> <to> [<infile> [<outfile>]] [-- <script-args>]

    Options:
        --help   -h      Show this help
        --debug  -d      Increase debug level by 1, can be repeated
        --list   -L      List transformations

    Transformations:
        alto2.0 alto3.0
        alto2.0 alto3.1
        alto2.0 hocr
        alto2.1 alto3.0
        alto2.1 alto3.1
        alto2.1 hocr
        alto text
        gcv hocr
        hocr alto2.0
        hocr alto2.1
        hocr text

    Saxon options:
        Usage: see http://www.saxonica.com/html/documentation/using-xsl/commandline.html
        Options available: -? -a -catalog -config -cr -diag -dtd -ea -expand -explain -export -ext -im -init -it -l -license -m -nogo -now -o -opt -or -outval -p -pack -quit -r -repeat -s -sa -scmin -strip -t -T -threads -TJ -TP -traceout -tree -u -val -versionmsg -warnings -x -xi -xmlversion -xsd -xsdversion -xsiloc -xsl -xsltversion -y
        Use -XYZ:? for details of option XYZ
        Params: 
          param=value           Set stylesheet string parameter
          +param=filename       Set stylesheet document parameter
          ?param=expression     Set stylesheet parameter using XPath
          !param=value          Set serialization parameter
</pre>

<!-- END-EVAL -->

### Transformation GUI

Select the `Transform` menu option. Choose a URL, an input and an output
format. Click `Transform`.

### Transformation API

The stylesheets are installed in `$PREFIX/share/ocr-fileformat/xslt` and can be
used directly in your scripts and software. You will need to use an XSLT 2.0
capable stylesheet transformer.

### Supported Transformations

| From ╲ To           | hOCR | ALTO | PAGEXML | FineReader | Google Cloud Vision |
| ---:                | ---  | ---  | ---     | ---        | ---                 |
| hOCR                | =    | ✓    | -       | -          | -                   |
| ALTO                | ✓    | =    | -       | -          | -                   |
| PAGEXML             | ✓    | -    | =       | -          | -                   |
| FineReader          | ✓    | -    | -       | =          | -                   |
| Google Cloud Vision | ✓    | -    | -       | -          | =                   |

## Validation


<!-- BEGIN-EVAL echo '<pre>';./bin/ocr-validate.sh -h 2>&1;echo '</pre>'  -->
<pre>
Usage: ocr-validate.sh [-dhL] <schema> <file> [<resultsFile>]

    Options:
        --help   -h      Show this help
        --debug  -d      Increase debug level by 1, can be repeated
        --list   -L      List available schemas

    Schemas:
        hocr 
        alto-1-0 alto-1-1 alto-1-2 alto-1-3 alto-1-4 alto-2-0 alto-2-1 alto-2-2-draft alto-3-0 alto-3-1 
        abbyy-6-schema-v1 abbyy-8-schema-v2 abbyy-9-schema-v1 abbyy-10-schema-v1 
        page-2009-03-16 page-2010-01-12 page-2010-03-19 page-2013-07-15 page-2016-07-15
</pre>

<!-- END-EVAL -->

### Validation CLI

For example, to validate an XML file againt the ALTO 3.1 schema:

```
ocr-validate alto-3-1 myFile.alto
```

### Validation GUI

Select the `Validate` menu option. Choose a URL and an schema. Click `Validate`.

### Validation API

The XSD files are installed under `$PREFIX/share/ocr-fileformat/xsd`

### Supported Validation Formats

|            | hOCR | ALTO | PAGEXML | FineReader | Google Cloud Vision |
| ---:       | ---  | ---  | ---     | ---        | ---                 |
| Validation | ✓    | ✓    | ✓       | ✓          | -                   |


## License

This is free software. You may use it under the terms of the [MIT License](LICENSE).

During the installation process several projects are included (in [`./vendor`](./blob/master/vendor)). These projects have different licenses:
* [Saxon HE 9.7](http://saxon.sourceforge.net/#F9.7HE), [`MPL`](https://www.mozilla.org/MPL/).
* [ALTOXML schema](https://github.com/altoxml/schema), ["Open Source"](https://github.com/altoxml/schema/issues/37#issuecomment-218730230) for ALTO <= 3.1, [`CC BY SA 4.0`](https://creativecommons.org/licenses/by-sa/4.0/legalcode) since ALTO 4.0
* [PAGE schemas](http://www.primaresearch.org/schema/PAGE/gts/pagecontent/), `?`
* [xsd-validator](https://github.com/kba/xsd-validator) by Adrian Mouat [@amouat](https://github.com/amouat), `Apache 2.0`
* ABBYY FineReader XSD, `?`
* [hOCR-to-ALTO](https://github.com/filak/hOCR-to-ALTO) by Filip Kriz [@filak](https://github.com/filak), [`MIT`](https://github.com/filak/hOCR-to-ALTO/blob/master/LICENSE.txt)
* [hocr-spec](https://github.com/kba/hocr-spec-python) by Konstantin Baierer [@kba](https://github.com/kba), [`MIT`](https://github.com/kba/hocr-spec-python/blob/master/LICENSE)
* [gcv2hocr](https://github.com/dinosauria123/gcv2hocr) by Endo Michiaki, [`CC BY 4.0`](https://creativecommons.org/licenses/by/4.0/legalcode)
* [format-converters](https://github.com/OCR-D/format-converters) by OCR-D, [`Apache 2.0`](https://github.com/OCR-D/format-converters/blob/master/LICENSE)
