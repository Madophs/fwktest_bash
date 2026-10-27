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

function test_try_execute_non_existing_file() {
    local __executable="/tmp/nonexiting_executable.sh"
    (bash "${__executable}" &> /dev/null)
    fwktest_assert_exit_code_equals $? 127
}

function test_array_contains_a_value() {
    local -a some_arr=('hola' 'çomo esta ñoño' 'some\ dir' '/path/to/file' '--branch' 'status')
    fwktest_assert_array_contains some_arr 'some\ dir'
    fwktest_assert_array_contains some_arr 'çomo esta ñoño'
    fwktest_assert_array_contains some_arr '--branch'
    fwktest_assert_not_array_contains some_arr 'çomo esta ñono'
}

function test_array_not_contains_a_value() {
    local -a some_arr=(hola como hola "hi /va _89")
    fwktest_assert_not_array_contains some_arr 'çomo'
    fwktest_assert_not_array_contains some_arr 'hi'
}

function test_function_with_numbers_123() {
    fwktest_assert_string_equals "${FUNCNAME[0]}" "test_function_with_numbers_123"
}

#function test_commented_function() {
#    fwktest_assert_string_equals "${FUNCNAME[0]}" "This function should be ignored"
#}

test_function_without_keyword ()
{
    fwktest_assert_string_equals "${FUNCNAME[0]}" "test_function_without_keyword"
}

function test_function_new_line   ()
{
    fwktest_assert_string_equals "${FUNCNAME[0]}" "test_function_new_line"
}
