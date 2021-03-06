#  Copyright (C) 2016 Tobias Oetiker

AUTOMAKE_OPTIONS =  foreign

SUBDIRS = etc lib thirdparty

BIN = bin/$(SCRIPT_NAME)
FENIX = bin/fenix

export PATH := /usr/gnu/bin:$(PATH)

PERLTESTS := $(shell test -d t && find t -name "*.t")

THIRDPARTY_DIR := $(shell pwd)/thirdparty
TEMPL := $(shell test -d templates && find templates -type f -name "*.ep")
SHARE := $(shell test -d share && find share -type f | egrep '\.(txt|pdf|ttf)$$')

EXTRA_DIST = VERSION COPYRIGHT README.md LICENSE CHANGES AUTHORS cpanfile $(BIN) $(FENIX) $(PERLTESTS) $(TEMPL) $(SHARE)

YEAR := $(shell date +%Y)
DATE := $(shell date +%Y-%m-%d)

datadir = $(prefix)
nobase_data_DATA = $(PUB) $(TEMPL) $(SHARE)

README.md COPYRIGHT : VERSION
	$(PERL) -i -p -e 's/(#VERSION#|\d+\.\d+\.\d+(?:-\w+)?)/$(PACKAGE_VERSION)/g;s/(#YEAR#|20[1-4]\d)/$(YEAR)/g;s/(#DATE#|20[1-9]\d-[01]\d-[0-3]\d)/$(DATE)/g;' $@

dist_bin_SCRIPTS = $(BIN) $(FENIX)

dist-hook: thirdparty $(POD)
	$(PERL) -i -p -e 's/^our\s+\$$VERSION\s*=\s*".+?";/our \$$VERSION = "$(PACKAGE_VERSION)";/;'  $(distdir)/lib/$(CLASS_NAME)/*.pm
	$(PERL) -i -p -e 's/^my .*# VERSION/my \$$VERSION = q{$(PACKAGE_VERSION)}; # VERSION/' $(distdir)/$(BIN)
	$(PERL) -i -p -e 's/^my .*# VERSION/my \$$VERSION = q{$(PACKAGE_VERSION)}; # VERSION/' $(distdir)/$(FENIX)

install-exec-hook:
	[ "$(PERL5LIB)" == "" ] || cd "$(DESTDIR)$(exec_prefix)" && $(PERL) -i -p -e 's{.*# PERL5LIB}{use lib qw($(PERL5LIB)); # PERL5LIB}' $(BIN) || true
	[ "$(PERL5LIB)" == "" ] || cd "$(DESTDIR)$(exec_prefix)" && $(PERL) -i -p -e 's{.*# PERL5LIB}{use lib qw($(PERL5LIB)); # PERL5LIB}' $(FENIX) || true
	cd "$(DESTDIR)$(exec_prefix)" && $(PERL) -i -p -e 's{.*# LIBDIR}{use lib qw($(libdir)); # LIBDIR}' $(BIN)
	cd "$(DESTDIR)$(exec_prefix)" && $(PERL) -i -p -e 's{.*# LIBDIR}{use lib qw($(libdir)); # LIBDIR}' $(FENIX)
	cd "$(DESTDIR)$(exec_prefix)" && $(PERL) -i -p -e 's{^#!.*perl.*}{#!$(PERL)};' $(BIN)
	cd "$(DESTDIR)$(exec_prefix)" && $(PERL) -i -p -e 's{^#!.*perl.*}{#!$(PERL)};' $(FENIX)
	cd "$(DESTDIR)$(libdir)" && $(PERL) -i -p -e 's{^my .*# CONFFILE}{my \$$CONFFILE = "$(sysconfdir)/$(SCRIPT_NAME).conf"; # CONFFILE};' OOCEapps.pm
	cd "$(DESTDIR)$(libdir)" && $(PERL) -i -p -e 's{^my .*# CONFFILE}{my \$$CONFFILE = "$(sysconfdir)/fenix.conf"; # CONFFILE};' Fenix.pm
	cd "$(DESTDIR)$(libdir)" && $(PERL) -i -p -e 's{^my .*# DATADIR}{my \$$DATADIR = "$(localstatedir)"; # DATADIR};' OOCEapps.pm
	cd "$(DESTDIR)$(libdir)" && $(PERL) -i -p -e 's{^my .*# DATADIR}{my \$$DATADIR = "$(localstatedir)"; # DATADIR};' Fenix.pm

test:
	$(PERL) "-MExtUtils::Command::MM" "-e" "test_harness(0, 'lib','thirdparty/lib/perl5')" $(PERLTESTS)
