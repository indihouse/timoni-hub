#!/usr/bin/env bash

set -e

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 project"
    exit 1
fi

# Find cue library dependencies
deps=$(moon project "$1" --json | jq -r '.dependencies | keys_unsorted | join(" ")')
cue_deps=""
for d in $deps; do
	type=$(moon project "$d" --json | jq -r '[.language,.type] | join("-")')
	if [ "$type" = "cue-library" ]; then
		cue_deps="$cue_deps $d"
	fi
done

# Vendoring cue library dependencies
for dep in $cue_deps; do
	droot=$(moon project "$dep" --json | jq -r '.root')
	modpath=$(cue eval -e module --out text "$droot/cue.mod/module.cue")
	target="cue.mod/pkg/$modpath"

	printf "Vendoring %s to $modpath..." "$dep"
	# Cleanup old version
	rm -rf "$target"
	mkdir -p "$target"
	# Extract the archive in that directory
	tar -xzf "$droot/build/$dep.tar.gz" -C "$target"
	echo " ✅"
done
