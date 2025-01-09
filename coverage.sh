#!/bin/bash

set -e

flutter test --coverage
#lcov --remove coverage/lcov.info 'lib/*.g.dart' -o coverage/new_lcov.info
lcov --remove coverage/lcov.info  -o coverage/new_lcov.info
genhtml coverage/new_lcov.info -o coverage/html --config-file coverage.config

genhtml coverage/new_lcov.info -o coverage/html | \
    grep "lines\.*:" | dart run coverage_check.dart 100.0

# Conditionally open only if running locally (not on CI)
if [ -z "$CI" ]; then
  # On a Mac:
  open coverage/html/index.html
  # or on Ubuntu with a desktop environment:
  # xdg-open coverage/html/index.html
fi
