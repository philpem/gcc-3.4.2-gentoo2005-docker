#!/bin/sh
set -e

cd "$(dirname "$0")/.."

IMAGE=${IMAGE:-gcc-3.4.2-gentoo2005:latest}

scripts/import-stage3.sh

exec docker build --platform linux/386 -t "$IMAGE" .
