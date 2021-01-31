#! /bin/bash
set -eo pipefail

source ./buildenv.sh

# build sqlite
if [ ! -d "sqlite-autoconf-3260000" ]; then
  ./unpackdep.sh https://www.sqlite.org/2018/sqlite-autoconf-3260000.tar.gz 5daa6a3fb7d1e8c767cd59c4ded8da6e4b00c61d3b466d0685e35c4dd6d7bf5d
  cd sqlite-autoconf-3260000
  ./configure --enable-static --disable-readline --disable-threadsafe --host=${TARGET_HOST} CC=$CC --prefix=${BUILDROOT}
  make -j ${NUM_JOBS}
  make install
  cd ..
fi

# build gmp
if [ ! -d "gmp-6.1.2" ]; then
  ./unpackdep.sh https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2 5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2
  cd gmp-6.1.2
  ./configure --enable-static --disable-assembly --host=${TARGET_HOST} CC=$CC --prefix=${BUILDROOT}
  make -j ${NUM_JOBS}
  make install
  cd ..
fi

# build libevent
if [ ! -d "libevent-release-2.1.11-stable" ]; then
  ./unpackdep.sh https://github.com/libevent/libevent/archive/release-2.1.11-stable.tar.gz 229393ab2bf0dc94694f21836846b424f3532585bac3468738b7bf752c03901e
  cd libevent-release-2.1.11-stable
  ./autogen.sh
  ./configure --prefix=${BUILDROOT} --enable-static --disable-samples \
              --disable-openssl --disable-shared --disable-libevent-regress --disable-debug-mode \
              --disable-dependency-tracking --host ${TARGET_HOST}
  make -o configure install -j${NUM_JOBS}
  cd ..
fi

# build zlib
if [ ! -d "zlib-1.2.11" ]; then
  ./unpackdep.sh https://github.com/madler/zlib/archive/v1.2.11.tar.gz 629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff
  cd zlib-1.2.11
  ./configure --static --prefix=${BUILDROOT}
  make -o configure install -j${NUM_JOBS}
  cd ..
fi

# build openssl
if [ ! -d "openssl-OpenSSL_1_1_1d" ]; then
  ./unpackdep.sh https://github.com/openssl/openssl/archive/OpenSSL_1_1_1d.tar.gz 23011a5cc78e53d0dc98dfa608c51e72bcd350aa57df74c5d5574ba4ffb62e74
  cd openssl-OpenSSL_1_1_1d
  SSLOPT="no-gost no-shared no-dso no-ssl3 no-idea no-hw no-dtls no-dtls1 \
          no-weak-ssl-ciphers no-comp -fvisibility=hidden no-err no-psk no-srp"

  if [ "$bits" = "64" ]; then
      SSLOPT="$SSLOPT enable-ec_nistp_64_gcc_128"
  fi
  ./Configure android-$NDKARCH --prefix=${BUILDROOT} $SSLOPT
  make depend
  make -j${num_jobs} 2> /dev/null
  make install_sw
  cd ..
fi

# build curl
if [ ! -d "curl-7.69.1" ]; then
  ./unpackdep.sh https://github.com/curl/curl/releases/download/curl-7_69_1/curl-7.69.1.tar.gz 01ae0c123dee45b01bbaef94c0bc00ed2aec89cb2ee0fd598e0d302a6b5e0a98
  cd curl-7.69.1
  ./configure --enable-static --disable-shared --prefix=${BUILDROOT} --target=${TARGET_HOST} --host=${TARGET_HOST} --with-ssl=${BUILDROOT} --with-zlib=${BUILDROOT}
  make -j ${NUM_JOBS}
  make install
  cd ..
fi