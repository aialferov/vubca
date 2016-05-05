# vim: noet

DESTDIR :=

PREFIX := usr/local
BINDIR := bin
SHAREDIR := share

BINPATH := $(DESTDIR)/$(PREFIX)/$(BINDIR)
SHAREPATH := $(DESTDIR)/$(PREFIX)/$(SHAREDIR)

all:

installdirs:
	mkdir -p $(BINPATH)
	mkdir -p $(SHAREPATH)

install: installdirs
	install -p -m 644 Vagrantfile $(SHAREPATH)
	install -p bootstrap.sh $(SHAREPATH)
	sed s:sharepath=.:sharepath=$(SHAREPATH): vubca > vubca.tmp
	install -p vubca.tmp $(BINPATH)/vubca
	rm -f vubca.tmp

uninstall:
	rm -f $(BINPATH)/vubca
	rm -f $(SHAREPATH)/bootstrap.sh
	rm -f $(SHAREPATH)/Vagrantfile
