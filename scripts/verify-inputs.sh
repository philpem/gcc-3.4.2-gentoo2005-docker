#!/bin/sh
set -e

cd "$(dirname "$0")/.."

echo "verifying stage3"
(cd inputs/stage3 && md5sum -c stage3-x86-2005.0.tar.bz2.MD5)

echo "verifying distfiles"
(cd inputs/distfiles && md5sum -c MD5SUMS)
