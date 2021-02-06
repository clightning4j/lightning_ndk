#! /bin/bash
set -eo pipefail

source ./buildenv.sh

# packaging
outputtar=${TARGET_HOST/v7a/}_lightning_ndk.tar
tar -cf ${outputtar} -C bitcoin/depends/${TARGET_HOST/v7a/}/bin bitcoind bitcoin-cli
tar -cf ${outputtar} ${BUILDROOT}/bin/tor
tar -rf ${outputtar} -C lightning lightningd/lightning_channeld lightningd/lightning_closingd lightningd/lightning_connectd lightningd/lightning_gossipd lightningd/lightning_hsmd lightningd/lightning_onchaind lightningd/lightning_openingd lightningd/lightningd
tar -rf ${outputtar} -C lightning plugins/autoclean plugins/keysend plugins/bcli plugins/esplora plugins/txprepare plugins/pay plugins/spenderp plugins/fetchinvoice plugins/offers
tar -rf ${outputtar} -C lightning cli/lightning-cli
xz ${outputtar}
