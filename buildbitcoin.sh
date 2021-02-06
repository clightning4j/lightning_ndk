#! /bin/bash
set -eo pipefail

source ./buildenv.sh

#bitcoin https://github.com/bitcoin/bitcoin.git 1bc9988993ee84bc814e5a7f33cc90f670a19f6a
#bitcoinknots https://github.com/bitcoinknots/bitcoin.git f8d8a318e8ff7fb396b3102a532c790a7430ed81
#liquid https://github.com/elementsproject/elements.git 928727ad6e626ac6ab45bb30867bd3519bc8ab25

reponame="bitcoin"
repo="https://github.com/bitcoin/bitcoin.git"
commit="1bc9988993ee84bc814e5a7f33cc90f670a19f6a"
configextra="--disable-man"


export CFLAGS="-flto"
export LDFLAGS="$CFLAGS -pie -static-libstdc++ -fuse-ld=lld"
export REPOPATH=$PWD

# build core
git clone ${repo} ${reponame}
cd ${reponame}
git checkout $commit

sed -i "s'/repo/'/${REPOPATH}/'" ${REPOPATH}/0001-android-patches.patch
patch -p1 < ${REPOPATH}/0001-android-patches.patch

if [ -f ${REPOPATH}/0001-android-patches-${commit}.patch ]; then
    patch -p1 < ${REPOPATH}/0001-android-patches-${commit}.patch
fi

(cd depends && make HOST=${TARGET_HOST/v7a/} NO_QT=1 -j ${NUM_JOBS})
./autogen.sh
./configure --prefix=$PWD/depends/${TARGET_HOST/v7a/} ac_cv_c_bigendian=no ac_cv_sys_file_offset_bits=$BITS --disable-bench --enable-experimental-asm --disable-tests --disable-man --without-utils --enable-util-cli --without-libs --with-daemon --disable-maintainer-mode --disable-glibc-back-compat ${configextra}
make -j ${NUM_JOBS}
make install
$STRIP depends/${TARGET_HOST/v7a/}/bin/${reponame}d
cd ..