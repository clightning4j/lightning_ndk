# lightning_ndk


Android cross-compilation of [c-lightning](https://github.com/ElementsProject/lightning) & [bitcoin](https://github.com/bitcoin/bitcoin) & [tor](https://github.com/torproject/tor) for Android >= 24 Api.

This project is based on [bitcoin_ndk](https://github.com/greenaddress/bitcoin_ndk) used in [ABCore](https://github.com/greenaddress/abcore).

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/clightning4j/lightning_ndk/ci?style=for-the-badge)

### Get binaries
Download the artifacts from the latest github [tagged release](https://github.com/clightning4j/lightning_ndk/releases).

The package archive `.tar.xz` contains: `ligthningd` (and ligthning deamons), ligthning plugins, esplora plugin, `ligthning-cli`, `bitcoind`, `bitcoin-cli` and `tor.`

### Build from sources
To build c-lightning with bitcoin follow the instructions:

```bash
bash build_deps.sh #download & install android ndk toolchain
export TARGET_HOST=aarch64-linux-android
export BITS=64
./buildenv.sh # set the toolchain variables based on your system
./buildlibs.sh # download & build dependency libraries
./buildlightning.sh # download & build clightning
./buildbitcoin.sh # download & build bitcoin core
./buildtor.sh # download & build bitcoin core
./archive.sh #prepare a compressed archive with the binaries
```

### Push to the device
Push all the binaries inside the archive to the android device, using `/data/local/tmp/` as binary folder.

```bash
adb push * /data/local/tmp/
```

### Run on the device
Run `lightningd` and connect to a `bitcoin` node, using `/sdcard/tmp/` as datadir.

```bash
adb shell
cd /data/local/tmp
chmod -R +x *
./lightningd/lightningd --lightning-dir=/sdcard/tmp/ --testnet --disable-plugin esplora
 --bitcoin-rpcconnect=$BITCOIN_HOST --bitcoin-rpcuser=$BITCOIN_USER 
 --bitcoin-rpcpassword=$BITCOIN_PWD --bitcoin-rpcport=$BITCOIN_PORT 
 --bitcoin-cli=/data/local/tmp/bitcoin-cli --bitcoin-datadir=/sdcard/tmp/ 
 --plugin-dir=/data/local/tmp/plugins --log-level=debug
```

If you want to use the esplora plugin as bitcoin backend

```bash
./lightningd/lightningd --lightning-dir=/sdcard/tmp/ --testnet --disable-plugin bcli
--esplora-api-endpoint=https://blockstream.info/testnet/api --log-level=debug 
```

### Local testing
Run cli command in an adb shell, as the following

```bash
./cli/lightning-cli --lightning-dir=/sdcard/tmp/ newaddr
```

### Dependencies
* sqlite lib [sqlite-autoreconf-3260000](https://www.sqlite.org/2018/sqlite-autoconf-3260000.tar.gz)
* gmp lib [gmp-6.1.2](https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2)
* android ndk [android-ndk-r20](https://dl.google.com/android/repository/android-ndk-r20-linux-x86_64.zip)

### References
* [INSTALL.md](https://github.com/ElementsProject/lightning/blob/master/doc/INSTALL.md#to-cross-compile-for-android)  of clightning to cross-compile c-lightning for Android
* [bitcoin_ndk](https://github.com/greenaddress/bitcoin_ndk/): ndk build of bitcoin core, knots and liquid
* [abcore](https://github.com/greenaddress/abcore/): ABCore - Android Bitcoin Core

### Acknowledgement
Thanks [domegabri](https://github.com/domegabri) to test this project on Android devices, and [dieeasy](https://github.com/dieeasy) from inbitcoin to test channels and pay invoices with [globular](https://gitlab.com/inbitcoin/globular).
