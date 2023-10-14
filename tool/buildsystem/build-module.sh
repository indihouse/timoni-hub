#!/usr/bin/env bash

set -e

builddir="build"

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 module-name [file2 file2 file3 ...]"
    exit 1
fi

# Ensure that the build directory exists
mkdir -p "$builddir"

# Build with default values
printf "Building %s with default values..." "$1"
timoni build "$1" -n default . > "$builddir/default.yaml"
echo " ✅"

for valuefile in "${@:2}"; do
	filename=$(basename "$valuefile")

	printf "Building %s with $filename..." "$1"
	timoni build "$1" -n default -f "$valuefile" . > "$builddir/${filename%.*}.yaml"
	echo " ✅"
done
