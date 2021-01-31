#! /bin/bash
set -eo pipefail

source ./buildenv.sh

export CFLAGS="-flto"
export LDFLAGS="$CFLAGS -pie -static-libstdc++ -fuse-ld=lld"

# build tor
./unpackdep.sh https://github.com/torproject/tor/archive/tor-0.4.2.5.tar.gz 94ad248f4d852a8f38bd8902a12b9f41897c76e389fcd5b8a7d272aa265fd6c9
cd tor-tor-0.4.2.5
./autogen.sh
TOROPT="--disable-system-torrc --disable-asciidoc --enable-static-tor --enable-static-openssl \
        --with-zlib-dir=$BUILDROOT --disable-systemd --disable-zstd \
        --enable-static-libevent --enable-static-zlib --disable-system-torrc \
        --with-openssl-dir=$BUILDROOT --disable-unittests \
        --with-libevent-dir=$BUILDROOT --disable-lzma \
        --disable-tool-name-check --disable-rust \
        --disable-largefile ac_cv_c_bigendian=no \
        --disable-module-dirauth"
./configure $TOROPT --prefix=${BUILDROOT} --host=${TARGET_HOST} --disable-android
make -o configure install -j${NUM_JOBS}
$STRIP $BUILDROOT/bin/tor
cd ..