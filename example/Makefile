# https://media.dwds.de/dta/images/wetzel_reisebegleiter_1901/wetzel_reisebegleiter_1901_0021_800px.jpg
BOOK=wetzel_reisebegleiter_1901
PAGE=0021
BASENAME=$(BOOK)_$(PAGE)

DEBIAN_PACKAGES = libxml2-utils tesseract-ocr tesseract-ocr-script-frak wget dwdiff
XMLLINT = xmllint --format
OCR_TRANSFORM = ../bin/ocr-transform.sh
ifdef HOMEBREW_PREFIX
TESSERACT = $(HOMEBREW_PREFIX)/bin/tesseract -l Fraktur
else
TESSERACT = /usr/bin/tesseract -l Fraktur
endif
WGET = wget
RM = rm -f
DWDIFF = dwdiff -p -l -c
PAGER = less -R
APT_GET = sudo apt-get -y

.PHONY: roundtrip
roundtrip: $(BASENAME).roundtrip.hocr $(BASENAME).alto.page

.PHONY: deps
deps:
	$(APT_GET) install $(DEBIAN_PACKAGES)

.PHONY: diff
diff: $(BASENAME).roundtrip.hocr $(BASENAME).hocr
	$(DWDIFF) $^ || exit 0

.PHONY: idiff
idiff: $(BASENAME).roundtrip.hocr $(BASENAME).hocr
	$(DWDIFF) $^ | $(PAGER)

$(BASENAME)_800px.jpg:
	$(WGET) http://media.dwds.de/dta/images/$(BOOK)/$(BASENAME)_800px.jpg

$(BASENAME).hocr : $(BASENAME)_800px.jpg
	$(TESSERACT) $< stdout hocr | $(XMLLINT) - > $@


$(BASENAME).alto : $(BASENAME).hocr
	$(OCR_TRANSFORM) hocr alto2.0 $< | $(XMLLINT) - > $@

$(BASENAME).alto.page : $(BASENAME).alto
	$(OCR_TRANSFORM) alto page $< | $(XMLLINT) - > $@

$(BASENAME).alto.page.alto : $(BASENAME).alto.page
	$(OCR_TRANSFORM) page alto $< | $(XMLLINT) - > $@

$(BASENAME).roundtrip.hocr : $(BASENAME).alto
	$(OCR_TRANSFORM) alto hocr $< | $(XMLLINT) - > $@

clean:
	$(RM) $(BASENAME)*.hocr $(BASENAME)*.alto
