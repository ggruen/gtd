# Make "sudo make prefix=/usr/local install" easy while maintaining backwrds
# compatibility
prefix=$(HOME)

SCRIPTS = \
    gtd \
    gtd-archive \
    gtd-config-read \
	gtd-i \
    gtd-init \
    gtd-upgrade \

# Scripts are documented with POD (either as a here doc in shell scripts or as
# POD in perl scripts).
# We assume any file with a line starting with "=head1" has POD we need to
# extract.
HAS_POD = $(shell egrep -l '^=head1 ' $(SCRIPTS))

MAN = $(patsubst %, %.1, $(HAS_POD))

all: $(MAN) $(SCRIPTS)

%.1 : %
	pod2man $< > $@

install: all
    # Fix missing "man" symlink in /usr/local on macOS (and anywhere else) per
    # Filesystem Heirarchy Standard
    # http://www.pathname.com/fhs/pub/fhs-2.3.html#USRLOCALSHARE1
	test "$(prefix)" = "/usr/local" && \
        { test -e /usr/local/man || \
        ln -s /usr/local/share/man /usr/local/man ; } || :
	install -d $(prefix)/man/man1
	install -d $(prefix)/bin
	install -m 444 $(MAN) $(prefix)/man/man1
	install -m 555 $(SCRIPTS) $(prefix)/bin
	rm $(MAN)

uninstall:
	test -d $(prefix)/bin && cd $(prefix)/bin && rm -f $(SCRIPTS)
	test -d $(prefix)/man/man1 && cd $(prefix)/man/man1 && rm -f $(MAN)

clean:
	rm $(MAN)

