#!/bin/bash

docker run -it -v `pwd`:/rpm arti.dev.cray.com/dstbuildenv-docker-master-local/cray-sle15sp3_build_environment:latest /bin/sh -c "cd /rpm; /bin/sh"
