#!/bin/sh
set -e

cd "$(dirname "$0")/.."

BASE=${BASE:-gentoo-2005.0-stage3:x86}
STAGE3=${STAGE3:-inputs/stage3/stage3-x86-2005.0.tar.bz2}

scripts/verify-inputs.sh

if docker image inspect "$BASE" >/dev/null 2>&1; then
    echo "stage3 base already imported: $BASE"
    exit 0
fi

echo "importing $STAGE3 as $BASE"
docker import --platform linux/386 "$STAGE3" "$BASE"
