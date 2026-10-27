#!/bin/env bash

function fwktest_helper_array_contains() {
    local -n __array_h=${1}
    local __value=${2}
    local __item
    for __item in "${__array_h[@]}"
    do
        [[ "${__value}" == "${__item}" ]] &&
            return 0
    done
    return 1
}

function fwktest_helper_array_not_contains() {
    ! fwktest_helper_array_contains "${1}" "${2}"
}
