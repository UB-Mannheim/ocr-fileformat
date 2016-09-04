CP = cp -rv
MKDIR = mkdir -p
RM = rm -rfv
UNZIP = unzip -u
WGET = wget --progress=bar:force --no-verbose
GIT_CLONE = git clone --depth 1

SAXON_HE_VERSION_MAJOR = 9
SAXON_HE_VERSION_MINOR = 7
SAXON_HE_VERSION_PATCH = 0-4J
SAXON_HE_ZIP = SaxonHE$(SAXON_HE_VERSION_MAJOR)-$(SAXON_HE_VERSION_MINOR)-$(SAXON_HE_VERSION_PATCH).zip
SAXON_HE_URL = https://sourceforge.net/projects/saxon/files/Saxon-HE/$(SAXON_HE_VERSION_MAJOR).$(SAXON_HE_VERSION_MINOR)/$(SAXON_HE_ZIP)/download
SAXON_HE_JAR = saxon9he.jar

PAGE_SCHEMA_REPO = page-schema
PAGE_SCHEMA_VERSIONS = 2009-03-16 2010-01-12 2010-03-19 2013-07-15
PAGE_SCHEMA_BASE_URL = http://www.primaresearch.org/schema/PAGE/gts/pagecontent/

ALTO_SCHEMA_REPO = alto-schema
ALTO_SCHEMA_URL = https://github.com/altoxml/schema

XSD_VALIDATOR_REPO = xsd-validator
XSD_VALIDATOR_URL = https://github.com/kba/xsd-validator

ABBYY_SCHEMA_REPO = abbyy-schema
ABBYY_SCHEMA_BASE_URL = http://www.abbyy.com/FineReader_xml/FineReader
ABBYY_SCHEMA_VERSIONS = 6-schema-v1 8-schema-v2 9-schema-v1 10-schema-v1

HOCR2ALTO_REPO = hOCR-to-ALTO
HOCR2ALTO_URL = https://github.com/kba/$(HOCR2ALTO_REPO)

HOCR_SPEC_REPO = hocr-spec-python
HOCR_SPEC_URL = https://github.com/kba/$(HOCR_SPEC_REPO)

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
	$(HOCR_SPEC_REPO)\
	$(SAXON_HE_JAR)

clean:
	$(RM) $(ALTO_SCHEMA_REPO)
	$(RM) $(SAXON_HE_JAR)
	$(RM) $(SAXON_HE_ZIP)
	$(RM) $(PAGE_SCHEMA_REPO)

check:
	@which \
		wget \
		unzip \
		git \
	>/dev/null

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
	$(GIT_CLONE) "$(HOCR2ALTO_URL)" "$@"

$(SAXON_HE_JAR):
	$(MAKE) $(SAXON_HE_ZIP)
	$(UNZIP) "$(SAXON_HE_ZIP)" "$@"

$(SAXON_HE_ZIP):
	$(WGET) -O "$@" "$(SAXON_HE_URL)"

$(HOCR_SPEC_REPO):
	$(GIT_CLONE) "$(HOCR_SPEC_URL)" "$@"
