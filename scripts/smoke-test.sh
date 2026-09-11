#!/bin/sh
set -e

IMAGE=${1:-${IMAGE:-gcc-3.4.2-gentoo2005:latest}}
EXPECTED='gcc (GCC) 3.4.2  (Gentoo Linux 3.4.2-r2, ssp-3.4.1-1, pie-8.7.6.5)'

docker run --rm --platform linux/386 -e "EXPECTED=$EXPECTED" "$IMAGE" sh -c '
    set -e
    test "$(gcc --version | sed -n 1p)" = "$EXPECTED"
    printf "int f(int x){return x*3;}\n" > /tmp/t.c
    gcc -c -O2 -march=i386 -o /tmp/t.o /tmp/t.c
    strings -a /tmp/t.o | grep -F "GCC: (GNU) 3.4.2  (Gentoo Linux 3.4.2-r2, ssp-3.4.1-1, pie-8.7.6.5)"
'
