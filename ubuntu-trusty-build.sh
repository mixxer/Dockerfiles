#!/bin/bash

set -e -x

docker build -t ubuntu-trusty $PWD/ubuntu-trusty
docker run --detach --publish=20022:22 --hostname=ubuntu-trusty-docker --name=ubuntu-trusty-docker ubuntu-trusty
docker stop ubuntu-trusty-docker
