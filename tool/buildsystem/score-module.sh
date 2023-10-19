#!/usr/bin/env bash

builddir="build"

files=$(find "$builddir" -name "*.yaml" -type f ! -name "default.yaml")

# If no files are found, exit
if [ -z "$files" ]; then
  echo "No files to test."
  exit 0
fi

# Run kube-score on all files
for f in $files; do
  echo "Running kube-score on $f"
  kube-score score \
    --ignore-container-cpu-limit \
    --ignore-container-memory-limit \
    --ignore-test \
    container-image-pull-policy \
    --ignore-test \
    pod-networkpolicy \
    --enable-optional-test \
    container-ports-check \
    "$f"
done
