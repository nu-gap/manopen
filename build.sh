#!/bin/sh
# Build with GNUstep's buildtool and package the page formatters.
set -eu
cd "$(dirname "$0")"
buildtool "$@"

# buildtool does not currently execute the Xcode Copy Files phase.
resources=build/ManOpenApplication/Products/ManOpen.app/Resources
cp build/cat2rtfTool/Products/cat2rtf "$resources/"
cp build/cat2htmlTool/Products/cat2html "$resources/"
