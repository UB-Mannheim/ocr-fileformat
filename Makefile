# Makefile for ocr-fileformat

PKG_NAME = ocr-fileformat
PKG_VERSION = 0.5.0
DOCKER_IMAGE = ubma/ocr-fileformat

# Either get the version from Git (if available) or use PKG_VERSION.
ROOTDIR = $(abspath $(dir $(MAKEFILE_LIST)))
VERSION = $(shell [ -d "$(ROOTDIR)/.git" ] && git -C "$(ROOTDIR)" describe --tags || echo $(PKG_VERSION))

CP = cp -r
LN = ln -sf
MV = mv -f
MKDIR = mkdir -p
RM = rm -rfv
ZIP = zip

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin
PYTHON = python3

TSHT = ./test/tsht
TSHT_URL = https://cdn.rawgit.com/kba/tsht/master/tsht

# BEGIN-EVAL makefile-parser --make-help Makefile

help:
	@echo ""
	@echo "  Targets"
	@echo ""
	@echo "    all        Download vendor assets, link XSD schemas and XSLT stylesheets"
	@echo "    vendor     Download all vendor assets"
	@echo "    xsd        Link all XSD schemas"
	@echo "    xslt       Link all XSLT stylesheets"
	@echo "    install    Install ocr-fileformat"
	@echo "    uninstall  Uninstall ocr-fileformat"
	@echo "    clean      Remove linked assets"
	@echo "    realclean  Remove linked assets and vendor files"
	@echo "    docker     Create the docker image"
	@echo "    release    Make release tarball / zipball"
	@echo
	@echo
	@echo "  Variables"
	@echo
	@echo "    PREFIX     Top-level directory for installation [$(PREFIX)]"
	@echo "    PYTHON     Python version to use for tools [$(PYTHON)]"

# END-EVAL

# Download vendor assets, link XSD schemas and XSLT stylesheets
all: vendor xsd xslt

check:
	$(MAKE) -C vendor check

.PHONY: vendor
# Download all vendor assets
vendor: check
	# download the dependencies
	git submodule update --init
	# create+activate a Python venv if not already active
	if [ -z "$(VIRTUAL_ENV)" ]; then \
	$(PYTHON) -m venv $(SHAREDIR)/venv && \
	. $(SHAREDIR)/venv/bin/activate && \
	pip install -U pip; \
	fi && $(MAKE) -C vendor all

.PHONY: xsd
# Link all XSD schemas
xsd: vendor
	$(MKDIR) xsd
	# copy Alto XSD
	cd xsd && $(LN) ../vendor/alto-schema/*/*.xsd . && \
		for xsd in *.xsd;do \
			target_xsd=`echo $$xsd|sed 's/.//g'|sed 's/-/./'`; \
			if [ ! -e $$target_xsd ];then \
				$(MV) $$xsd $$target_xsd; \
			fi; done
	# copy PAGE XSD
	@cd xsd && $(LN) ../vendor/page-schema/*.xsd .
	# copy ABBYY XSD
	cd xsd && $(LN) ../vendor/abbyy-schema/*.xsd .

.PHONY: xslt
# Link all XSLT stylesheets
xslt: vendor
	$(MKDIR) xslt
	# symlink hocr<->alto as well as the language codes lookup xml
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/hocr__alto2.0.xsl hocr__alto2.0.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/hocr__alto2.1.xsl hocr__alto2.1.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/hocr__alto3.xsl hocr__alto3.0.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/hocr__alto4.xsl hocr__alto4.0.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/alto__hocr.xsl alto__hocr.xsl
	cd xslt && $(LN) alto__hocr.xsl alto2.0__hocr.xsl
	cd xslt && $(LN) alto__hocr.xsl alto2.1__hocr.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/hocr__text.xsl hocr__text.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/alto__text.xsl alto__text.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/codes_lookup.xml codes_lookup.xml
	cd xslt && $(LN) ../vendor/format-converters/page2hocr.xsl page__hocr.xsl
	cd xslt && $(LN) ../vendor/format-converters/abbyy2hocr.xsl abbyy__hocr.xsl
	cd xslt && $(LN) alto2.0__alto3.0.xsl alto2.0__alto3.1.xsl
	cd xslt && $(LN) alto2.0__alto3.0.xsl alto2.1__alto3.0.xsl
	cd xslt && $(LN) alto2.0__alto3.0.xsl alto2.1__alto3.1.xsl
	cd xslt && $(LN) ../vendor/im2alto/iw2alto.xsl mybib__alto3.0.xsl

# Install ocr-fileformat
define SEDSCRIPT
cat <<"EOF"
/^SHAREDIR=/c\
SHAREDIR="$(SHAREDIR)"
s/VERSION/$(VERSION)/
EOF
endef
export SEDSCRIPT
install: all
	$(MKDIR) $(SHAREDIR)
	$(CP) script xsd xslt vendor lib.sh $(SHAREDIR)
	$(MKDIR) $(BINDIR)
	eval "$$SEDSCRIPT" | sed -f - bin/ocr-transform.sh > $(BINDIR)/ocr-transform
	eval "$$SEDSCRIPT" | sed -f - bin/ocr-validate.sh  > $(BINDIR)/ocr-validate
	chmod a+x $(BINDIR)/ocr-transform $(BINDIR)/ocr-validate
	find $(SHAREDIR) -not -type l -exec chmod u+w {} \;

# Uninstall ocr-fileformat
uninstall:
	$(RM) $(BINDIR)/ocr-transform
	$(RM) $(BINDIR)/ocr-validate
	$(RM) $(SHAREDIR)

# Remove linked assets
clean:
	$(RM) xsd/*
	find xslt -type l -delete

# Remove linked assets and vendor files
realclean: clean
	$(MAKE) -C vendor clean

# Create the docker image
docker:
	docker build -t "$(DOCKER_IMAGE)" .

# Make release tarball / zipball
release:
	$(RM) $(PKG_NAME)_$(PKG_VERSION)
	$(MKDIR) $(PKG_NAME)_$(PKG_VERSION)
	tar -X .zipignore -cf - . | tar -xf - -C $(PKG_NAME)_$(PKG_VERSION)
	# $(CP) LICENSE Makefile README.md bin/ lib.sh vendor/
	tar czf $(PKG_NAME)_$(PKG_VERSION).tar.gz $(PKG_NAME)_$(PKG_VERSION)
	zip --symlinks -r $(PKG_NAME)_$(PKG_VERSION).zip $(PKG_NAME)_$(PKG_VERSION)
