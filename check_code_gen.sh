#!/bin/bash

set -e

flutter clean

flutter pub get

flutter packages pub run build_runner build --delete-conflicting-outputs  

if [[ $(git diff) ]]; then
    echo "code get changed something.. you forgot to run \"run build_runner build\"... ⛔️ "
    exit 1
else
    echo "code gen changed nothing.. awesome!!! ✅"
fi