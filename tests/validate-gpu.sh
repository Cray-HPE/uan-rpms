#!/usr/bin/env bash
# Copyright 2021 Hewlett Packard Enterprise Development LP

if [[ $# -ne 1 ]]; then
  echo "Must specify a single argument of nvidia or amd"
  exit 1
fi

export GPU=$(echo $1 | tr '[:upper:]' '[:lower:]')
if [[ "$GPU" != "nvidia" && "$GPU" != "amd" ]]; then
  echo "Must specify a single argument of nvidia or amd"
  exit 1
fi

ROOTDIR="$(dirname "${BASH_SOURCE[0]}")"
export GOSS_BASE=${ROOTDIR}/goss

goss --vars ${GOSS_BASE}/tests/goss-gpu-vars.yaml \
     --gossfile ${GOSS_BASE}/tests/goss-gpu.yaml \
     validate
