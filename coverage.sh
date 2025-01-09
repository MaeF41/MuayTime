#!/bin/bash

set -e

flutter test --coverage
#lcov --remove coverage/lcov.info 'lib/*.g.dart' -o coverage/new_lcov.info
lcov --remove coverage/lcov.info  -o coverage/new_lcov.info
genhtml coverage/new_lcov.info -o coverage/html --config-file coverage.config
open coverage/html/index.html
genhtml coverage/new_lcov.info -o coverage/html | grep "lines\.*:" | dart run coverage_check.dart 100.0
