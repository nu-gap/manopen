#!/bin/sh
# Run after sh build.sh. Requires GNUstep, clang, an X display, and manpages.
set -eu
cd "$(dirname "$0")/.."
for formatter in cat2rtf cat2html; do
    if [ ! -x "build/ManOpenApplication/Products/ManOpen.app/Resources/$formatter" ]; then
        echo "Missing bundled formatter $formatter. Run sh build.sh before testing." >&2
        exit 1
    fi
done
test_dir=$(mktemp -d /tmp/manopen-test.XXXXXX)
cp -R build/ManOpenApplication/Products/ManOpen.app "$test_dir/ManOpen.app"
clang $(gnustep-config --objc-flags) -IManOpen Tests/OpenManPage.m \
    build/ManOpenApplication/AproposDocument.m.o \
    build/ManOpenApplication/FindPanelController.m.o \
    build/ManOpenApplication/ManDocument.m.o \
    build/ManOpenApplication/ManDocumentController.m.o \
    build/ManOpenApplication/NSData+Utils.m.o \
    build/ManOpenApplication/PrefPanelController.m.o \
    -o "$test_dir/ManOpen.app/ManOpen" $(gnustep-config --gui-libs)
"$test_dir/ManOpen.app/ManOpen"
