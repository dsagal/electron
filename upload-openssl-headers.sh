#!/bin/bash
# Usage in 3-0-x series (if build instructions as in
# https://github.com/electron/electron/blob/3-0-x/docs/development/build-instructions-osx.md)
#
# 1. Follow build instructions until bootstrap.py step.
#    - When checking out code, check it out at a version tag, e.g v3.0.7
#    - Clean out dist/ directory if there is stale stuff there
#      rm -rf dist/
# 2. build.py step is probably not necessary (or OK if it doesn't complete in full)
# 3. From the electron/ checkout directory, run ./upload-openssl-headers.sh
#    script with no arguments.
# 4. Check the results with `aws s3 ls --recursive s3://electron-headers-openssl`

set -x

VERSION=$(node -p -e "require('./package.json').version")
BUCKET=electron-headers-openssl
export AWS_PROFILE=electron-headers-openssl

python script/create-node-headers.py -v v${VERSION}

export ELECTRON_S3_BUCKET=$BUCKET
export ELECTRON_S3_ACCESS_KEY=`aws configure get aws_access_key_id`
export ELECTRON_S3_SECRET_KEY=`aws configure get aws_secret_access_key`
python script/upload-node-headers.py -v v${VERSION}

export ELECTRON_DIST_URL=https://${BUCKET}.s3.amazonaws.com/atom-shell/dist/
python script/upload-node-checksums.py -v v${VERSION} --dist-url=$ELECTRON_DIST_URL
