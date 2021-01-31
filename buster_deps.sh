#!/bin/bash
set -eo pipefail
export NDK_VERSION=android-ndk-r21d
export NDK_FILENAME=${NDK_VERSION}-linux-x86_64.zip
export ACCEPT_EULA=Y

sha256_file=dd6dc090b6e2580206c64bcee499bc16509a5d017c6952dcd2bed9072af67cbd

sudo apt-get -yqq update
#sudo apt-get -yqq upgrade
sudo apt-get -yqq install python3 python3-{pip,virtualenv,mako} curl build-essential libtool autotools-dev automake pkg-config bsdmainutils unzip git gettext
python3 -m pip install virtualenv

mkdir -p /opt

cd /opt && curl -sSO https://dl.google.com/android/repository/${NDK_FILENAME}
echo "${sha256_file}  ${NDK_FILENAME}" | shasum -a 256 --check
unzip -qq ${NDK_FILENAME}
rm ${NDK_FILENAME}

if [ -f /.dockerenv ]; then
    sudo apt-get -yqq --purge autoremove unzip
    sudo apt-get -yqq clean
    rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /usr/share/locale/* /usr/share/man /usr/share/doc /lib/xtables/libip6*
fi
