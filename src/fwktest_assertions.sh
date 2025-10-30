#!/bin/bash

source "${FWKTEST_SRC}/fwktest_print.sh"

[ ! -v __counter_total_assertions ] && declare -g -i __counter_total_assertions=0
[ ! -v __counter_failed_assertions ] && declare -g -i __counter_failed_assertions=0

# @brief evaluate test expression
# @args --eval = evaluate passed expression literally, otherwise uses conventional "test" command
function fwktest_eval() {
    __counter_total_assertions+=1
    if [[ "${1}" == "--eval" ]]
    then
        shift
        eval "${@}" &> /dev/null # We don't want to show any output
    else
        test "${@}"
    fi

    if [ ! $? -eq 0 ]
    then
        __counter_failed_assertions+=1
        return 1
    fi
}

function fwktest_assert_file() {
    local __file_location=${1}
    fwktest_eval -f "${__file_location}" || fwktest_print fail "Failed to assert that file '${__YELLOW}${__file_location}${__BLK}' exists."
}

function fwktest_assert_dir() {
    local __dir_location=${1}
    fwktest_eval -d "${__dir_location}" || fwktest_print fail "Failed to assert that directory '${__YELLOW}${__dir_location}${__BLK}' exists."
}

function fwktest_assert_executable() {
    local __file_location=${1}
    fwktest_eval -f "${__file_location}" || fwktest_print fail "Failed to assert that executable '${__YELLOW}${__file_location}${__BLK}' exists."
    fwktest_eval -x "${__file_location}" || fwktest_print fail "Failed to assert that file '${__YELLOW}${__file_location}${__BLK}' is executable."
}

function fwktest_assert_string_equals() {
    local __str1="${1}"
    local __str2="${2}"
    fwktest_eval "${__str1}" = "${__str2}" || fwktest_print fail "Failed to assert that string '${__YELLOW}${__str1}${__BLK}' equals '${__YELLOW}${__str2}${__BLK}'."
}

function fwktest_assert_digit_equals() {
    local __int1="${1}"
    local __int2="${2}"
    fwktest_eval "${__int1}" = "${__int2}" || fwktest_print fail "Failed to assert that integer '${__YELLOW}${__int1}${__BLK}' equals '${__YELLOW}${__int2}${__BLK}'."
}

function fwktest_assert_digit_less_than() {
    local __int1="${1}"
    local __int2="${2}"
    fwktest_eval "${__int1}" -lt "${__int2}" || fwktest_print fail "Failed to assert that integer '${__YELLOW}${__int1}${__BLK}' is less than '${__YELLOW}${__int2}${__BLK}'."
}

function fwktest_assert_digit_greater_than() {
    local __int1="${1}"
    local __int2="${2}"
    fwktest_eval "${__int1}" -gt "${__int2}" || fwktest_print fail "Failed to assert that integer '${__YELLOW}${__int1}${__BLK}' is greater than '${__YELLOW}${__int2}${__BLK}'."
}

function fwktest_assert_file_content_same_as() {
    local __filepath1="${1}"
    local __filepath2="${2}"
    fwktest_eval --eval "cmp" "${__filepath1}" "${__filepath2}" || fwktest_print fail "Failed to assert that file '${__YELLOW}${__filepath1}${__BLK}' content is same as '${__YELLOW}${__filepath2}${__BLK}'."
}

function fwktest_assert_exit_code_equals() {
    local __int1="${1}"
    local __int2="${2}"
    fwktest_eval "${__int1}" = "${__int2}" || fwktest_print fail "Failed to assert that exit code '${__YELLOW}${__int1}${__BLK}' equals '${__YELLOW}${__int2}${__BLK}'."
}
