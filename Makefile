PKG_NAME = ocr-transform

CP = cp -rv
LN = ln -sf
MV = mv -f

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin

.PHONY: check \
	install uninstall \
	clean realclean \
	vendor

check:
	$(MAKE) -C $($@) check
	@which \
		wget \
		unzip \
		git \
	>/dev/null

vendor:
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

install: check $(VENDOR_DIRNAME)
	$(MKDIR) $(SHAREDIR)
	$(CP) -t $(SHAREDIR) xsd xslt vendor
	$(MKDIR) $(BINDIR)
	sed '/^SHAREDIR=/c SHAREDIR="$(SHAREDIR)"' bin/ocr-transform.sh > $(BINDIR)/ocr-transform
	sed '/^SHAREDIR=/c SHAREDIR="$(SHAREDIR)"' bin/ocr-validate.sh > $(BINDIR)/ocr-validate
	chmod a+x $(BINDIR)/$(PKG_NAME)

uninstall:
	$(RM) $(BINDIR)/$(PKG_NAME)
	$(RM) $(SHAREDIR)

clean:
	$(RM) xsd/*

realclean: clean
	$(MAKE) -C vendor clean
