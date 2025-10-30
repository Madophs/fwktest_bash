#!/bin/bash
source ./fwktest_incl.sh
fwktest_add_test_dir "./examples"
fwktest_evaluate
echo "Don't worry this example, is not expected to pass all tests"
