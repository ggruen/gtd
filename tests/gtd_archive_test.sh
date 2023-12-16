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
    export XDG_CONFIG_HOME="$gtd_dir/.config"
    gtd init -q -d "$gtd_dir"
}

tearDown() {
    cd "$SCRIPTDIR" || exit 1
}

testArchiveMovesProjectFolderToArchiveFolder() {
    # Make sure we don't start writing files places that could break things
    test "$XDG_CONFIG_HOME" || {
        echo "XDG_CONFIG_HOME isn't set. Check oneTimeSetup function." >&2
        exit 1
    }

    test "$gtd_dir" || {
        echo "gtd_dir not set - checkout oneTimeSetup function." >&2
        exit 1
    }

    # Given a folder in the project support folder
    mkdir -p "$(gtd config read project_support_directory)/test_project"

    # When I archive it
    printf "%s\n" "Archiving $(gtd config read project_support_directory)/test_project"
    mkdir -p "$(gtd config read project_archive_directory)"
    gtd archive project test_project

    # Then it's in the archive folder
    assertTrue "[ -d \"$(gtd config read project_archive_directory)/test_project\" ]"

    # and not in the project support folder
    assertFalse "[ -e \"$(gtd config read project_support_directory)/test_project\" ]"
}

oneTimeTearDown() {
    cd "$SCRIPTDIR" || exit 1
    ./test_teardown.sh
}

# shellcheck disable=SC1091
. ./shunit2
