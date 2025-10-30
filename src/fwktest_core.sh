#!/bin/bash

[ ! -v __test_dirs ] && declare -a __test_dirs=()

# @brief adds directory containings the tests
# reminder test's filenames must start with prefix "test_"
function fwktest_add_test_dir() {
    for __dir in "${@}"
    do
        if [[ ! -d "${__dir}" ]]
        then
            printf "Error: <%s> is not a directory\n" "${__dir}"
            exit 1
        else
            __test_dirs+=("${__dir}")
        fi
    done
}

function fwktest_evaluate() {
    declare -a __test_files=()
    for __path in ${__test_dirs[@]}
    do
        __test_files+=($(find "${__path}" -name "test_*.sh"))
    done

    if [[ ${#__test_files[@]} -eq 0 ]]
    then
        printf "Error: no tests found.\n"
        exit 1
    fi

    for (( __index=0; __index<${#__test_files[@]}; __index+=1 ))
    do
        local __test_file="${__test_files[${__index}]}"
        local __filename="$(echo "${__test_file}" | awk -F '/' '{print $NF}')"
        local __test_dir="$(echo "${__test_file}" | grep -o '.*/')"

        # Grep all test functions
        local -a __test_func=($(grep -o -E 'test_[a-zA-Z_]+\(\)' "${__test_file}" | sed 's/()//g'))
        if [[ ${#__test_func} -eq 0 ]]
        then
            echo "No tests found for <${__test_file}>"
            continue
        fi

        printf "Test #%d\nFile : %s\n" ${__index} "${__filename}"
        # Execute test functions
        pushd "${__test_dir}" &> /dev/null
        source "./${__filename}"
        local -i __filetest_failed_assertions_before_call=${__counter_failed_assertions}
        local -i __filetest_total_assertions_before_call=${__counter_total_assertions}
        for __function in "${__test_func[@]}"
        do
            local -i __function_failed_assertions_before_call=${__counter_failed_assertions}
            local -i __function_total_assertions_before_call=${__counter_total_assertions}

            # Calling the function
            ${__function}

            local -i __function_total_assertions=$(( __counter_total_assertions - __function_total_assertions_before_call ))
            local -i __function_total_fails=$(( __counter_failed_assertions - __function_failed_assertions_before_call ))
            local -i __function_total_pass=$(( __function_total_assertions - __function_total_fails ))

            if (( __function_total_fails != 0 ))
            then
                fwktest_print failed "${__function}" "${__function_total_pass}/${__function_total_assertions}"
            else
                fwktest_print pass "${__function}" "${__function_total_pass}/${__function_total_assertions}"
            fi
        done

        local -i __filetest_total_assertions=$(( __counter_total_assertions - __filetest_total_assertions_before_call ))
        local -i __filetest_total_fails=$(( __counter_failed_assertions - __filetest_failed_assertions_before_call ))
        local -i __filetest_total_pass=$(( __filetest_total_assertions - __filetest_total_fails ))

        fwktest_print status "${__filename}" "${__filetest_total_pass}/${__filetest_total_assertions}"
        popd &> /dev/null
    done

    if (( __counter_failed_assertions == 0 ))
    then
        fwktest_print tests_passed
    else
        local -i __counter_passed_assertions=$(( __counter_total_assertions - __counter_failed_assertions ))
        fwktest_print tests_failed ${__counter_passed_assertions} ${__counter_failed_assertions} ${__counter_total_assertions}
    fi
}
