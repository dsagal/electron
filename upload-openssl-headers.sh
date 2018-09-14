#!/bin/bash

set -x

VERSION=1.7.11
BUCKET=electron-headers-openssl
export AWS_PROFILE=electron-headers-openssl

python script/create-node-headers.py -v v${VERSION}

export ELECTRON_S3_BUCKET=$BUCKET
export ELECTRON_S3_ACCESS_KEY=`aws configure get aws_access_key_id`
export ELECTRON_S3_SECRET_KEY=`aws configure get aws_secret_access_key`
python script/upload-node-headers.py -v v${VERSION}

export ELECTRON_DIST_URL=https://${BUCKET}.s3.amazonaws.com/atom-shell/dist/
python script/upload-node-checksums.py -v v${VERSION}
