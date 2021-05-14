# Copyright 2021 Hewlett Packard Enterprise Development LP

ROOTDIR="$(dirname "${BASH_SOURCE[0]}")"
WORKDIR=$(mktemp -d)

cp $ROOTDIR/* $WORKDIR
pushd $WORKDIR

# The module command does not return exit codes correctly
# so attempt to load a module and check for error output
# If no error ouput is detected, load the module again
# to set paths correctly
if module load rocm 2>&1 | grep "Unable to locate"; then
  echo Could not load rocm 
  echo FAIL
  exit 1
fi

module load rocm

make
if [ $? -ne 0 ]; then
  echo make command failed
  echo FAIL
  exit 1
fi

./HelloWorld
if [ $? -ne 0 ]; then
  echo ./HelloWorld failed
  echo FAIL
  exit 1
fi

popd; rm -r $WORKDIR

echo PASS

exit 0
