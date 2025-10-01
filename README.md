# gtd
Command-line GTD system

# Synopsis

    # Tell gtd where your Inbox, Project Support, Archive and Reference folders are
    gtd init

    # Add "build_lunar_base.txt" to inbox, pop into $EDITOR to edit
    gtd i Build lunar base

    # Archive "Update complicated Mac App" project
    gtd archive "Update complicated Mac App"

# Description

`gtd` is a command-line tool that implements a basic GTD system.
You put projects into a Project Support directory. That also serves as your
list of projects.
You put new ideas into an "Inbox" folder.
Add an inbox item with "gtd i" - it opens `$EDITOR` and you can type. Also dump
any other kind of file into your inbox, because it's just a directory on your
computer. Your project list is `cdp && ls`.

I recommend setting up aliases - I use this in my `.bashrc`:

```bash
# Command-line GTD shortcuts
if command -v gtd > /dev/null ; then
    alias cdp='cd "$(gtd config-read project_support_directory)"'
    alias cdr='cd "$(gtd config-read reference_materials_directory)"'
    alias cdi='cd "$(gtd config-read inbox_directory)"'
fi
```

Will this replace all of your GTD toys? No - but it's handy to toss items into
a flexible inbox, check out your project support folder, and archive things. I
personally use it in combination with Microsoft To Do for task management, and
manual access to my Project Support and Reference folders (since Finder or File
Explorer are pretty powerful tools for file management already).

# Installation

- Download the files
- `cd gtd`
- `sudo make prefix=/usr/local install` (you can also just do `make install` to
  install into ~/.local/bin and ~/.local/share/man)

# Setup

`gtd init` - opens the config file in `$EDITOR` with some default settings

# Upgrade

`gtd upgrade`

# Help

`gtd` installs `man` pages. So, you can do git-style lookups like `man
gtd-init`, `man gtd`, etc.
