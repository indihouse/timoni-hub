#!/usr/bin/env bash

set -e

builddir="build"
testdir="test"

testcases=$(find $testdir -type f -name "*.expected.yaml")

# Check if at least one test is provided
if [ -z "$testcases" ]; then
    echo "No test to run."
    exit 0
fi

for tc in $testcases; do
	filename=$(basename "$tc")
	test="${filename%%.*}"
	actual="$builddir/$test.yaml"

	# Check if actual file exists
	if [ ! -f "$actual" ]; then
		echo "Test $test failed: $actual does not exist."
		echo "Is the corresponding test/$test.cue defined?"
		exit 1
	fi

	# Diff actual and expected
	dyff between -is "$tc" "$actual"
done
