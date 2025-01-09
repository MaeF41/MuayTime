#!/bin/bash

set -eu

flutter pub get
flutter build web --release --web-renderer=auto --verbose
