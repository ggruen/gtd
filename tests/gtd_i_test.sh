#!/usr/bin/env bash

# Make sure we're running the scripts we should be testing
SCRIPTDIR=$( pwd -P )
PATH="${SCRIPTDIR}/../:/bin:/usr/bin:/usr/local/bin"

oneTimeSetUp() {
    # gtd-init creates the config file in $XDG_CONFIG_HOME, so set it to a safe
    # place to test
    gtd_dir=/tmp/gtd_test
    rm -rf "$gtd_dir"
    mkdir "$gtd_dir"
    mkdir "$gtd_dir/Inbox"
    export XDG_CONFIG_HOME="$gtd_dir/.config"
    gtd init -q -d "$gtd_dir"
}

tearDown() {
    cd "$SCRIPTDIR" || exit 1
}

testgtdInboxCreatesFile() {
    # Given an inbox item title
    title="Do some Things"
    export EDITOR="touch"

    # When gtd-i is run with it
    # (note that we want title to expand into multiple arguments)
    #shellcheck disable=SC2086
    gtd i $title

    # Then a file with that name, lower-cased and de-spaced, appears in the inbox
    assertTrue "File should exist in inbox" \
        "[ -f \"$(gtd config read inbox_directory)/do_some_things.txt\" ]"
}

oneTimeTearDown() {
    cd "$SCRIPTDIR" || exit 1
    ./test_teardown.sh
}

# shellcheck disable=SC1091
. ./shunit2
