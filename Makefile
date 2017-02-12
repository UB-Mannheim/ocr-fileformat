PKG_NAME = ocr-fileformat
PKG_VERSION = 0.2.0
DOCKER_IMAGE = ubma/ocr-fileformat

CP = cp -r
LN = ln -sf
MV = mv -f
MKDIR = mkdir -p
RM = rm -rfv
ZIP = zip

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin

TSHT = ./test/tsht
TSHT_URL = https://cdn.rawgit.com/kba/tsht/master/tsht

all: vendor xsd xslt

check:
	$(MAKE) -C vendor check

.PHONY: vendor
vendor: check
	# download the dependencies
	$(MAKE) -C vendor all

.PHONY: xsd
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
xslt: vendor
	$(MKDIR) xslt
	# symlink hocr<->alto
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/hocr2alto2.0.xsl hocr__alto2.0.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/hocr2alto2.1.xsl hocr__alto2.1.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/alto2hocr.xsl alto2.0__hocr.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/alto2hocr.xsl alto2.1__hocr.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/hocr2text.xsl hocr__text.xsl
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/alto2text.xsl alto__text.xsl
	# language codes lookup (new in version 1.3.2):
	cd xslt && $(LN) ../vendor/hOCR-to-ALTO/codes_lookup.xml codes_lookup.xml
	cd xslt && $(LN) alto2.0__alto3.0.xsl alto2.0__alto3.1.xsl
	cd xslt && $(LN) alto2.0__alto3.0.xsl alto2.1__alto3.0.xsl
	cd xslt && $(LN) alto2.0__alto3.0.xsl alto2.1__alto3.1.xsl

install: all
	$(MKDIR) $(SHAREDIR)
	$(CP) script xsd xslt vendor lib.sh $(SHAREDIR)
	$(MKDIR) $(BINDIR)
	sed '/^SHAREDIR=/c SHAREDIR="$(SHAREDIR)"' bin/ocr-transform.sh > $(BINDIR)/ocr-transform
	sed '/^SHAREDIR=/c SHAREDIR="$(SHAREDIR)"' bin/ocr-validate.sh > $(BINDIR)/ocr-validate
	chmod a+x $(BINDIR)/ocr-transform $(BINDIR)/ocr-validate
	find $(SHAREDIR) -exec chmod u+w {} \;

uninstall:
	$(RM) $(BINDIR)/ocr-transform
	$(RM) $(BINDIR)/ocr-validate
	$(RM) $(SHAREDIR)

clean:
	$(RM) xsd/*
	find xslt -type l -delete

realclean: clean
	$(MAKE) -C vendor clean

docker:
	docker build -t "$(DOCKER_IMAGE)" .

release:
	$(RM) $(PKG_NAME)_$(PKG_VERSION)
	$(MKDIR) $(PKG_NAME)_$(PKG_VERSION)
	tar -X .zipignore -cf - . | tar -xf - -C $(PKG_NAME)_$(PKG_VERSION)
	# $(CP) LICENSE Makefile README.md bin/ lib.sh vendor/
	tar czf $(PKG_NAME)_$(PKG_VERSION).tar.gz $(PKG_NAME)_$(PKG_VERSION)
	zip --symlinks -r $(PKG_NAME)_$(PKG_VERSION).zip $(PKG_NAME)_$(PKG_VERSION)
