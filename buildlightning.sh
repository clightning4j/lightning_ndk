#! /bin/bash
set -eo pipefail

source ./buildenv.sh
REPOPATH=$PWD

# download lightning
git clone https://github.com/ElementsProject/lightning.git lightning
cd lightning
git checkout v0.10.0

# set virtualenv for lightning
python3 -m virtualenv venv
source venv/bin/activate
pip install -r requirements.txt

# provide generated config file instead run configure
cp ${REPOPATH}/lightning-header_versions_gen.h header_versions_gen.h
cp ${REPOPATH}/lightning-version_gen.h version_gen.h
# update arch based on toolchain
sed "s'NDKCOMPILER'${CC}'" ${REPOPATH}/lightning-config.vars > config.vars
sed "s'NDKCOMPILER'${CC}'" ${REPOPATH}/lightning-config.h > ccan/config.h
sed -i "s'BUILDROOT'${BUILDROOT}'" config.vars

# patch makefile
sed -i "s'/usr/local'${BUILDROOT}'" Makefile
sed -i "s'-lpthread''" Makefile
sed -i "s'ALL_C_HEADERS := header_versions_gen.h version_gen.h'ALL_C_HEADERS :='" Makefile
sed -i "s'./configure'#./configure'" Makefile
sed -i "s'include bitcoin/test/Makefile''" bitcoin/Makefile
patch -p1 < ${REPOPATH}/lightning-addr.patch
patch -p1 < ${REPOPATH}/lightning-endian.patch

# add esplora plugin
git clone https://github.com/lvaccaro/esplora_clnd_plugin.git
cd esplora_clnd_plugin && git checkout master && cd ..
cp esplora_clnd_plugin/esplora.c plugins/
sed -i 's/LDLIBS = /LDLIBS = -lcurl -lssl -lcrypto /g' Makefile
patch -p1 < esplora_clnd_plugin/Makefile.patch

# build external libraries and source
make PIE=1 DEVELOPER=0 || echo "continue"
make clean -C ccan/ccan/cdump/tools
make LDFLAGS="" CC="${CONFIGURATOR_CC}" LDLIBS="-L/usr/local/lib" -C ccan/ccan/cdump/tools
make PIE=1 DEVELOPER=0
deactivate
cd ..
