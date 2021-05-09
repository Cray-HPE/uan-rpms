# Copyright 2021 Hewlett Packard Enterprise Development LP

ROOTDIR="$(dirname "${BASH_SOURCE[0]}")"
WORKDIR=$(mktemp -d)

cp $ROOTDIR/* $WORKDIR
pushd $WORKDIR

module load cudatoolkit
make

./hello

popd
rm -r $WORKDIR

echo PASS

exit 0
