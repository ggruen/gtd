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
}

tearDown() {
    cd "$SCRIPTDIR" || exit 1
}

testGtdInitPointsToSpecifiedDirectotry() {
    # Make sure we don't start writing files places that could break things
    test "$XDG_CONFIG_HOME" || {
        echo "XDG_CONFIG_HOME isn't set. Check oneTimeSetup function." >&2
        exit 1
    }

    test "$gtd_dir" || {
        echo "gtd_dir not set - checkout oneTimeSetup function." >&2
        exit 1
    }

    # Given a specified GTD directory
    config_file="$XDG_CONFIG_HOME/gtd/config"

    # When it's passed to gtd-init's -d flag
    gtd init -q -d "$gtd_dir"

    # Then the values in the config file point to that directory
#    printf "%s\n" "Config file:" >&2
#    cat "$config_file" >&2
    project_support_line="$(grep -E '^project_support_directory' "$config_file")"
    assertContains \
        "$project_support_line should contain $gtd_dir/Project Support" \
        "$project_support_line" \
        "$gtd_dir/Project Support"
    assertContains \
        "$(grep -E '^project_archive_directory:' "$config_file")" \
        "$gtd_dir/Archive/Project Support"
    assertContains \
        "$(grep -E '^reference_materials_directory:' "$config_file")" \
        "$gtd_dir/Reference"
    assertContains \
        "$(grep -E '^reference_materials_archive_directory:' "$config_file")" \
        "$gtd_dir/Archive/Reference"

    # Clean up
    rm "$config_file"
}

testGtdInitHandlesDefaultDirectoryProperly() {
    # Make sure we don't start writing files places that could break things
    test "$XDG_CONFIG_HOME" || {
        echo "XDG_CONFIG_HOME isn't set. Check oneTimeSetup function." >&2
        exit 1
    }

    test "$gtd_dir" || {
        echo "gtd_dir not set - checkout oneTimeSetup function." >&2
        exit 1
    }

    # Given gtd-init is called without specifying a root directory (-d)
    config_file="$XDG_CONFIG_HOME/gtd/config"
    rm -f "$config_file"
    assertFalse "[[ -f \"$config_file\" ]]"

    # When it is run
    gtd-init -q -t

    # Then it creates the config file
    assertTrue "[[ -f \"$config_file\" ]]"

    # Clean up
    rm "$config_file"
}

oneTimeTearDown() {
    cd "$SCRIPTDIR" || exit 1
    ./test_teardown.sh
}

# shellcheck disable=SC1091
. ./shunit2
