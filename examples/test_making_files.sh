#!/bin/bash

#source ../src/* 2> /dev/null

function test_create_simple_file() {
    #local simple_temp_file="$(mktemp)"
    simple_temp_file="/tmp/haha"
    fwktest_assert_file "${simple_temp_file}"
}

function test_strings_are_equal() {
    fwktest_assert_string_equals "hola" "hi"
    fwktest_assert_string_equals "como estas" "como estas"
}

function test_files_contents_are_same_fails() {
    local __file1="/tmp/fwktest_file1"
    local __file2="/tmp/fwktest_file2"
    echo -e "don't know\nwhat to write\nbut, you know\nthat's it" > "${__file1}"
    cp "${__file1}" "${__file2}"
    sed -i '2,2d' "${__file2}" # Delete second line
    fwktest_assert_file_content_same_as "${__file1}" "${__file2}"
}
