#! /bin/bash
set -eo pipefail

archive=$(basename $1)
curl -sL -o ${archive} $1
echo "$2 ${archive}" | sha256sum --check
tar xf ${archive}
rm ${archive}