PACKAGE_NAME = ocr-transform

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PACKAGE_NAME)
BINDIR = $(PREFIX)/bin

CP = cp -rv
MKDIR = mkdir -p
RM = rm -rfv

SAXON_HE_VERSION = 9-7-0-4J
SAXON_HE_ZIP = SaxonHE$(SAXON_HE_VERSION).zip
SAXON_HE_JAR = saxon9he.jar
SAXON_HE_URL = https://sourceforge.net/projects/saxon/files/Saxon-HE/9.7/$(SAXON_HE_ZIP)/download

# SAXON_BROWSER_VERSION = 1.1
# SAXON_BROWSER_ZIP = Saxon-CE_$(SAXON_BROWSER_VERSION).zip
# SAXON_BROWSER_JS =  TODO
# SAXON_BROWSER_URL = http://www.saxonica.com/ce/download/$(SAXON_BROWSER_ZIP)

# $(SAXON_BROWSER_JS): $(SAXON_BROWSER_ZIP)

# $(SAXON_BROWSER_ZIP):
#     wget -O '$@' '$(SAXON_BROWSER_URL)'

$(SAXON_HE_JAR): $(SAXON_HE_ZIP)
	unzip $< $@

$(SAXON_HE_ZIP):
	wget -O '$@' '$(SAXON_HE_URL)'

install: $(SAXON_HE_JAR)
	$(MKDIR) $(SHAREDIR)
	$(CP) -t $(SHAREDIR) *.xsl
	$(CP) -t $(SHAREDIR) $(SAXON_HE_JAR)
	$(MKDIR) $(BINDIR)
	sed 's,SHAREDIR=".",SHAREDIR="$(SHAREDIR)",' bin/$(PACKAGE_NAME).sh > $(BINDIR)/$(PACKAGE_NAME)
	chmod a+x $(BINDIR)/$(PACKAGE_NAME)

uninstall:
	$(RM) $(BINDIR)/$(PACKAGE_NAME)
	$(RM) $(SHAREDIR)

clean:
	$(RM) $(SAXON_HE_JAR)

realclean: clean
	$(RM) $(SAXON_HE_ZIP)
