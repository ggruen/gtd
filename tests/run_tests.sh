#!/usr/bin/env bash

tests=$(echo ./*_test.sh | sed 's#./##g')
runner_passing_=0

for t in ${tests}; do
  echo
  echo "--- Executing the \"${t}\" test suite. ---"
  ( "./${t}" 2>&1; )
  test "${runner_passing_}" -eq 0 -a $? -eq 0
  runner_passing_=$? # Sets runner_passing_ to the output of the "test" command
done

test $runner_passing_ -eq 0 && echo "Tests passed" || echo "Tests failed"
exit ${runner_passing_}
