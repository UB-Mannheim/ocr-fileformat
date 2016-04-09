# Testing transformations

Install dependencies. For Debian/Ubuntu:

    make deps

Run a roundtrip example:

    make roundtrip

This will:

* download image (`-> x.jpg`)
* OCR the image (`-> x.hocr`)
* hOCR -> ALTO 2.0 (`-> x.alto`)
* ALTO 2.0 -> hOCR (`-> x.roundtrip.hocr`)

To see the information lost/added:

    make diff

This will compare `x.hocr` to `x.roundtrip.hocr` using `dwdiff` and open the result in a pager.

