PKG_NAME = ocr-transform

CP = cp -r
LN = ln -sf
MV = mv -f
MKDIR = mkdir -p
RM = rm -rfv

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin

.PHONY: check \
	install uninstall \
	clean realclean \
	vendor

check:
	$(MAKE) -C vendor check

vendor: check
	# download the dependencies
	$(MAKE) -C vendor all
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

install: vendor $(VENDOR_DIRNAME)
	$(MKDIR) $(SHAREDIR)
	$(CP) -t $(SHAREDIR) xsd xslt vendor lib.sh
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

realclean: clean
	$(MAKE) -C vendor clean
