CP = cp -rv
MKDIR = mkdir -p
RM = rm -rfv
UNZIP = unzip -o
WGET = wget --progress=bar:force --no-verbose
GIT_CLONE = git clone --depth 1

SAXON_HE_VERSION_MAJOR = 9
SAXON_HE_VERSION_MINOR = 9
SAXON_HE_VERSION_PATCH = 1-7J
SAXON_HE_ZIP = SaxonHE$(SAXON_HE_VERSION_MAJOR)-$(SAXON_HE_VERSION_MINOR)-$(SAXON_HE_VERSION_PATCH).zip
SAXON_HE_URL = https://netcologne.dl.sourceforge.net/project/saxon/Saxon-HE/$(SAXON_HE_VERSION_MAJOR).$(SAXON_HE_VERSION_MINOR)/$(SAXON_HE_ZIP)
SAXON_HE_JAR = saxon9he.jar

PAGE_SCHEMA_REPO = page-schema
PAGE_SCHEMA_VERSIONS = 2009-03-16 2010-01-12 2010-03-19 2013-07-15 2016-07-15 2017-07-15 2018-07-15 2019-07-15
PAGE_SCHEMA_BASE_URL = https://github.com/PRImA-Research-Lab/PAGE-XML/blob/master/PAGE-release/gts/pagecontent

ALTO_SCHEMA_REPO = alto-schema
ALTO_SCHEMA_URL = https://github.com/altoxml/schema

XSD_VALIDATOR_REPO = xsd-validator
XSD_VALIDATOR_URL = https://github.com/kba/xsd-validator

ABBYY_SCHEMA_REPO = abbyy-schema
ABBYY_SCHEMA_BASE_URL = http://fr7.abbyy.com/FineReader_xml/FineReader
ABBYY_SCHEMA_VERSIONS = 6-schema-v1 8-schema-v2 9-schema-v1 10-schema-v1

HOCR2ALTO_REPO = hOCR-to-ALTO
HOCR2ALTO_URL = https://github.com/filak/$(HOCR2ALTO_REPO)
HOCR2ALTO_COMMITID = c80ad8d3a6c1330d6bbcb147d83e4b17b109f4f3

HOCR_SPEC_REPO = hocr-spec-python
HOCR_SPEC_URL = https://github.com/kba/$(HOCR_SPEC_REPO)

GCV2HOCR_REPO = gcv2hocr
GCV2HOCR_URL = https://github.com/dinosauria123/$(GCV2HOCR_REPO)

PAGE2HOCR_REPO = format-converters
PAGE2HOCR_URL = https://github.com/OCR-D/$(PAGE2HOCR_REPO)

ALTO2PAGE_VERSION_MAJOR_MINOR = 1.5
ALTO2PAGE_VERSION = $(ALTO2PAGE_VERSION_MAJOR_MINOR).05
ALTO2PAGE_ZIP = JPageConverter.zip
ALTO2PAGE_URL = https://github.com/PRImA-Research-Lab/prima-page-converter/releases/download/$(ALTO2PAGE_VERSION)/JPageConverter_$(ALTO2PAGE_VERSION).zip
ALTO2PAGE_DIR = JPageConverter

# {{{
# SAXON_BROWSER_VERSION = 1.1
# SAXON_BROWSER_ZIP = Saxon-CE_$(SAXON_BROWSER_VERSION).zip
# SAXON_BROWSER_JS =  TODO
# SAXON_BROWSER_URL = http://www.saxonica.com/ce/download/$(SAXON_BROWSER_ZIP)

# $(SAXON_BROWSER_JS): $(SAXON_BROWSER_ZIP)

# $(SAXON_BROWSER_ZIP):
#     wget -O '$@' '$(SAXON_BROWSER_URL)'
#}}}

.PHONY: all check $(PAGE_SCHEMA_REPO) $(ABBYY_SCHEMA_REPO)

all:\
	$(PAGE_SCHEMA_REPO)\
	$(ALTO_SCHEMA_REPO)\
	$(ABBYY_SCHEMA_REPO)\
	$(XSD_VALIDATOR_REPO)\
	$(HOCR2ALTO_REPO)\
	$(GCV2HOCR_REPO)\
	$(PAGE2HOCR_REPO)\
	$(HOCR_SPEC_REPO)\
	$(SAXON_HE_JAR) \
	$(ALTO2PAGE_DIR)

clean:
	$(RM) $(ALTO_SCHEMA_REPO)
	$(RM) $(SAXON_HE_JAR)
	$(RM) $(SAXON_HE_ZIP)
	$(RM) $(PAGE_SCHEMA_REPO)
	$(RM) $(ALTO2PAGE_DIR)
	$(RM) $(ALTO2PAGE_ZIP)

check:
	@which wget >/dev/null || (echo "Missing wget. Please install package wget." && exit 1)
	@which unzip >/dev/null || (echo "Missing unzip. Please install package unzip." && exit 1)
	@which git >/dev/null || (echo "Missing git. Please install package git." && exit 1)

$(ABBYY_SCHEMA_REPO):
	@$(MKDIR) "$@" && cd "$@" && \
		for version in $(ABBYY_SCHEMA_VERSIONS);do \
			xsd=abbyy-$$version.xsd; if [ ! -e $$xsd ];then \
				$(WGET) -O $$xsd $(ABBYY_SCHEMA_BASE_URL)$$version.xml; \
			fi; \
		done;

$(PAGE_SCHEMA_REPO):
	@$(MKDIR) "$@" && cd "$@" && \
		for version in $(PAGE_SCHEMA_VERSIONS);do \
			xsd=page-$$version.xsd; if [ ! -e $$xsd ];then \
				$(WGET) -O $$xsd $(PAGE_SCHEMA_BASE_URL)/$$version/pagecontent.xsd; \
			fi; \
		done;

$(XSD_VALIDATOR_REPO):
	$(GIT_CLONE) "$(XSD_VALIDATOR_URL)" "$@"

$(ALTO_SCHEMA_REPO):
	$(GIT_CLONE) "$(ALTO_SCHEMA_URL)" "$@"

$(HOCR2ALTO_REPO):
	git clone "$(HOCR2ALTO_URL)" "$@"
	cd "$@" && git checkout $(HOCR2ALTO_COMMITID)

$(SAXON_HE_JAR):
	$(MAKE) $(SAXON_HE_ZIP)
	$(UNZIP) "$(SAXON_HE_ZIP)" "$@"

$(SAXON_HE_ZIP):
	$(WGET) -O "$@" "$(SAXON_HE_URL)"

$(HOCR_SPEC_REPO):
	$(GIT_CLONE) "$(HOCR_SPEC_URL)" "$@"

$(GCV2HOCR_REPO):
	$(GIT_CLONE) "$(GCV2HOCR_URL)" "$@"
	$(MAKE) -C $(GCV2HOCR_REPO)

$(PAGE2HOCR_REPO):
	$(GIT_CLONE) "$(PAGE2HOCR_URL)" "$@"

$(ALTO2PAGE_ZIP):
	$(WGET) -O "$@" "$(ALTO2PAGE_URL)"

$(ALTO2PAGE_DIR): $(ALTO2PAGE_ZIP)
	$(UNZIP) "$<"
	mv "JPageConverter $(ALTO2PAGE_VERSION_MAJOR_MINOR)" "$@"
