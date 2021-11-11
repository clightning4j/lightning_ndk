#! /bin/bash
set -eo pipefail

export NDK_VERSION=android-ndk-r21d
export ANDROID_NDK_HOME=/opt/$NDK_VERSION
export PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:${PATH}
export AR=${TARGET_HOST/v7a}-ar
export AS=${TARGET_HOST}24-clang
export CC=${TARGET_HOST}24-clang
export CXX=${TARGET_HOST}24-clang++
export LD=${TARGET_HOST/v7a}-ld
export STRIP=${TARGET_HOST/v7a}-strip
export LDFLAGS="-pie"
export MAKE_HOST=${TARGET_HOST/v7a}
export HOST=${TARGET_HOST/v7a}
export CONFIGURATOR_CC="/usr/bin/gcc"

NDKARCH=arm
BUILD=armv7
if [ "$TARGET_HOST" = "i686-linux-android" ]; then
    NDKARCH=x86
    BUILD=x86
elif [ "$TARGET_HOST" = "x86_64-linux-android" ]; then
    NDKARCH=x86_64
    BUILD=x86_64
elif [ "$TARGET_HOST" = "aarch64-linux-android" ]; then
    NDKARCH=arm64
    BUILD=aarch64
fi
export NDKARCH=${NDKARCH}
export BUILD=${BUILD}

num_jobs=$(nproc)
if [ -f /proc/cpuinfo ]; then
    num_jobs=$(grep ^processor /proc/cpuinfo | wc -l)
fi
export NUM_JOBS${num_jobs}

export BUILDROOT=$PWD/build_root
mkdir -p $BUILDROOT
