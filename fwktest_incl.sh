#!/bin/bash

FWKTEST_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
FWKTEST_SRC="${FWKTEST_ROOT}/src"

source "${FWKTEST_SRC}/fwktest_print.sh"
source "${FWKTEST_SRC}/fwktest_core.sh"
source "${FWKTEST_SRC}/fwktest_assertions.sh"
