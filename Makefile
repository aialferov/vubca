# vim: noet

PKGROOT :=
DESTDIR :=

PREFIX := usr/local
BINDIR := bin
SHAREDIR := share

BINPATH := $(DESTDIR)/$(PREFIX)/$(BINDIR)
SHAREPATH := $(DESTDIR)/$(PREFIX)/$(SHAREDIR)

all:

installdirs:
	mkdir -p $(PKGROOT)/$(BINPATH)
	mkdir -p $(PKGROOT)/$(SHAREPATH)

install: installdirs
	install -p -m 644 Vagrantfile $(PKGROOT)/$(SHAREPATH)
	install -p bootstrap.sh $(PKGROOT)/$(SHAREPATH)
	sed s:sharepath=.:sharepath=$(SHAREPATH): vubca > vubca.tmp
	install -p vubca.tmp $(PKGROOT)/$(BINPATH)/vubca
	rm -f vubca.tmp

uninstall:
	rm -f $(PKGROOT)/$(BINPATH)/vubca
	rm -f $(PKGROOT)/$(SHAREPATH)/bootstrap.sh
	rm -f $(PKGROOT)/$(SHAREPATH)/Vagrantfile
