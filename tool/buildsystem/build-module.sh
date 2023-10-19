#!/usr/bin/env bash

set -e

builddir="build"
testdir="test"

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 module-name"
    exit 1
fi

# Ensure that the build directory exists
mkdir -p "$builddir"

# Build with default values
printf "Building %s with default values..." "$1"
timoni build "$1" -n default . > "$builddir/default.yaml"
echo " ✅"

# Build test values
shopt -s globstar nullglob
returncode=0
for f in "$testdir"/*.cue; do
	filename=$(basename "$f")

	printf "Building %s with $f..." "$1"
	timoni build "$1" -n default -f "$f" . > "$builddir/${filename%.*}.yaml"
	status=$?
	if [ $status -ne 0 ]; then
		returncode=$status
	else
		echo " ✅"
	fi
done

exit $returncode
