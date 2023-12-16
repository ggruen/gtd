#!/usr/bin/env bash

# Make sure we're running the scripts we should be testing
SCRIPTDIR=$( pwd -P )
PATH="${SCRIPTDIR}/../:/bin:/usr/bin:/usr/local/bin"

oneTimeSetUp() {
    ./test_setup.sh
}

tearDown() {
    cd "$SCRIPTDIR" || exit 1
}

testMakeInstallSucceeds() {
    cd "$SCRIPTDIR/.." || exit 1
    make prefix=/tmp/gtd_test_install install
    assertTrue "make install shouldn't fail" $?

    test -d /tmp/gtd_test_install/bin
    assertTrue "bin dir should exist" $?

    test -d /tmp/gtd_test_install/man/man1
    assertTrue "man/man1 dirs should exist in /tmp/gtd_test_install" $?

    rm -rf /tmp/gtd_test_install
    return 0
}


oneTimeTearDown() {
    ./test_teardown.sh
}

# shellcheck disable=SC1091
. ./shunit2
