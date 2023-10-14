#!/usr/bin/env bash

set -e

builddir="build"

kube-score score \
      --ignore-container-cpu-limit \
      --ignore-container-memory-limit \
      --ignore-test \
      container-image-pull-policy \
      --ignore-test \
      pod-networkpolicy \
      --enable-optional-test \
      container-ports-check \
      $builddir/*.yaml
