#!/bin/bash

#source ../src/* 2> /dev/null

function test_create_simple_file() {
    #local simple_temp_file="$(mktemp)"
    simple_temp_file="/tmp/haha"
    fwktest_assert_file "${simple_temp_file}"
}

function test_strings_are_equal() {
    fwktest_assert_string_equals "hola" "hi"
}
