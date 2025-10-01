# Make "sudo make prefix=/usr/local install" easy while maintaining backwards
# compatibility and respecting the XDG Base Directory Specification.
#
# Defaults:
#   prefix      -> ~/.local               (XDG user-specific tree)
#   bindir      -> $(prefix)/bin
#   mandir      -> $(datarootdir)/man
#   man1dir     -> $(mandir)/man1
#
# Special‑case: if you set `prefix=$(HOME)` **or** if you already have
# `~/bin` and `~/man`, we keep that flat layout so man pages end up in
# `~/man/man1` instead of `~/.local/share/man/man1`.
#
# Usage examples:
#   make install                    # installs to ~/.local/...
#   make prefix=$(HOME) install     # installs to ~/bin and ~/man/...
#   sudo make prefix=/usr/local install

# ----- Prefix ---------------------------------------------------------------
prefix ?= $(HOME)/.local

# ----- Derived dirs (XDG / GNU style) ---------------------------------------
ifeq ($(prefix),$(HOME))
  datarootdir ?= $(prefix)          # legacy ~/man, ~/info …
else
  datarootdir ?= $(prefix)/share
endif

bindir   ?= $(prefix)/bin
mandir   ?= $(datarootdir)/man
man1dir  ?= $(mandir)/man1

# If ~/man already exists, respect it even if datarootdir was overridden
ifeq ($(prefix),$(HOME))
  ifneq ($(wildcard $(prefix)/man),)
    mandir  := $(prefix)/man
    man1dir := $(mandir)/man1
  endif
endif

# ----- Project files --------------------------------------------------------
SCRIPTS = \
    gtd \
    gtd-archive \
    gtd-config-read \
    gtd-i \
    gtd-init \
    gtd-upgrade \

# Any script containing POD is assumed to need a man page.
HAS_POD = $(shell egrep -l '^=head1 ' $(SCRIPTS))
MAN      = $(patsubst %, %.1, $(HAS_POD))

.PHONY: all install uninstall clean

all: $(MAN) $(SCRIPTS)

%.1: %
	pod2man $< > $@

install: all
	# Preserve legacy /usr/local/man symlink on macOS & FHS systems
	@test "$(prefix)" = "/usr/local" && \
	{ test -e /usr/local/man || ln -s /usr/local/share/man /usr/local/man ; } || :
	install -d "$(man1dir)" "$(bindir)"
	install -m 444 $(MAN) "$(man1dir)"
	install -m 555 $(SCRIPTS) "$(bindir)"
	rm -f $(MAN)

uninstall:
	@test -d "$(bindir)"  && cd "$(bindir)"  && rm -f $(SCRIPTS) || :
	@test -d "$(man1dir)" && cd "$(man1dir)" && rm -f $(MAN)     || :

clean:
	rm -f $(MAN)
