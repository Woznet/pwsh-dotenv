#!/usr/bin/env bash

set -u;

SCRIPT_DIR=$(cd $(dirname $0); pwd)

pushd $SCRIPT_DIR > /dev/null

pwsh -File Test-Run.ps1
ret=$?

popd > /dev/null

exit $ret
