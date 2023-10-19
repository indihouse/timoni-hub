#!/usr/bin/env bash

builddir="build"
testdir="test"

shopt -s globstar nullglob
returncode=0
for tc in "$testdir"/*.expected.yaml; do
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
	status=$?
	if [ $status -ne 0 ]; then
		returncode=$status
	fi
done

exit $returncode
