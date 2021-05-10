# Copyright 2021 Hewlett Packard Enterprise Development LP

ROOTDIR="$(dirname "${BASH_SOURCE[0]}")"
WORKDIR=$(mktemp -d)

cp $ROOTDIR/* $WORKDIR
pushd $WORKDIR

# module unfortunately does not have correct error codes
# pipe stderr to stdout and parse the output to determine
# failure
module load cudatoolkit 2>&1 | grep "Unable to locate"
if [ $? -eq 0 ]; then
  echo Could not load cudatoolkit
  echo FAIL
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo make command failed
  echo FAIL
  exit 1
fi

./hello

popd
rm -r $WORKDIR

echo PASS

exit 0
