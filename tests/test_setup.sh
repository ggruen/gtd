#!/usr/bin/env bash
# Set up test data before any given set of test runs
# Must be sourced as it changes the directory and sets environment variables.

./test_teardown.sh # Start with a clean slate

# We'll pretend /tmp/gtd_test is our home directory, and put our GTD docs into
# a Documents subdirectory.
mkdir /tmp/gtd_test || exit 1
export XDG_CONFIG_HOME="/tmp/gtd_test/.config"

