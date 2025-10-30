#!/bin/bash

source "${FWKTEST_SRC}/fwktest_print.sh"

function fwktest_assert_file() {
    local __file_location=${1}
    test -f "${__file_location}" || fwktest_print fail "Failed to assert that file '${YELLOW}${__file_location}${BLK}' exists."
}

function fwktest_assert_dir() {
    local __dir_location=${1}
    test -d "${__dir_location}" || fwktest_print fail "Failed to assert that directory '${YELLOW}${__dir_location}${BLK}' exists."
}

function fwktest_assert_executable() {
    local __file_location=${1}
    test -f "${__file_location}" || fwktest_print fail "Failed to assert that executable '${YELLOW}${__file_location}${BLK}' exists."
    test -x "${__file_location}" || fwktest_print fail "Failed to assert that file '${YELLOW}${__file_location}${BLK}' is executable."
}

function fwktest_assert_string_equals() {
    local __str1="${1}"
    local __str2="${2}"
    test "${__str1}" = "${__str2}" || fwktest_print fail "Failed to assert that string '${YELLOW}${__str1}${BLK}' equals '${YELLOW}${__str2}${BLK}'."
}

function fwktest_assert_digit_equals() {
    local __int1="${1}"
    local __int2="${2}"
    test "${__int1}" = "${__int2}" || fwktest_print fail "Failed to assert that integer '${YELLOW}${__int1}${BLK}' equals '${YELLOW}${__int2}${BLK}'."
}

function fwktest_assert_digit_less_than() {
    local __int1="${1}"
    local __int2="${2}"
    test "${__int1}" -lt "${__int2}" || fwktest_print fail "Failed to assert that integer '${YELLOW}${__int1}${BLK}' equals '${YELLOW}${__int2}${BLK}'."
}

function fwktest_assert_digit_greater_than() {
    local __int1="${1}"
    local __int2="${2}"
    test "${__int1}" -gt "${__int2}" || fwktest_print fail "Failed to assert that integer '${YELLOW}${__int1}${BLK}' equals '${YELLOW}${__int2}${BLK}'."
}
