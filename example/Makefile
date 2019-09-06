# http://media.dwds.de/dta/images/wetzel_reisebegleiter_1901/wetzel_reisebegleiter_1901_0021_800px.jpg
BOOK=wetzel_reisebegleiter_1901
PAGE=0021
BASENAME=$(BOOK)_$(PAGE)

DEBIAN_PACKAGES = libxml2-utils tesseract-ocr tesseract-ocr-deu-frak wget dwdiff
XMLLINT = xmllint --format
OCR_TRANSFORM = ../bin/ocr-transform.sh
TESSERACT = tesseract
WGET = wget
RM = rm -f
DWDIFF = dwdiff -p -l -c
PAGER = less -R
APT_GET = sudo apt-get -y

.PHONY: roundtrip
roundtrip: $(BASENAME).roundtrip.hocr

.PHONY: deps
deps:
	$(APT_GET) install $(DEBIAN_PACKAGES)

.PHONY: diff
diff: $(BASENAME).roundtrip.hocr $(BASENAME).hocr
	$(DWDIFF) $^ || exit 0

.PHONY: diff
idiff: $(BASENAME).roundtrip.hocr $(BASENAME).hocr
	$(DWDIFF) $^ | $(PAGER)

$(BASENAME)_800px.jpg:
	$(WGET) http://media.dwds.de/dta/images/$(BOOK)/$(BASENAME)_800px.jpg

$(BASENAME).hocr : $(BASENAME)_800px.jpg
	$(TESSERACT) -l Fraktur $< stdout hocr | $(XMLLINT) - > $@

$(BASENAME).alto : $(BASENAME).hocr
	$(OCR_TRANSFORM) hocr alto2.0 $< | $(XMLLINT) - > $@

$(BASENAME).roundtrip.hocr : $(BASENAME).alto
	$(OCR_TRANSFORM) alto2.0 hocr $< | $(XMLLINT) - > $@

clean:
	$(RM) $(BASENAME)*.hocr $(BASENAME)*.alto
