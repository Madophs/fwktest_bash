#!/bin/bash

source ../../fwktest_incl.sh

function __sum_number() {
    local -i a=${1}
    local -i b=${2}
    local -n result_ref=${3}
    result_ref=$(( a + b ))
}

function test_simple_sum_failed() {
    local -i __res=0
    __sum_number 77 88 __res
    __res+=1
    fwktest_assert_digit_equals ${__res} 165
}

function test_simple_sum_ok() {
    local -i __res=0
    __sum_number 77 88 __res
    fwktest_assert_digit_equals ${__res} 165
}
