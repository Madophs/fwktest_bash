#!/bin/bash

[ ! -v __test_dirs ] && declare -a __test_dirs=()

# @brief adds directory containings the tests
# reminder test's filenames must start with prefix "test_"
function fwktest_add_test_dir() {
    for __dir in "${@}"
    do
        if [[ ! -d "${__dir}" ]]
        then
            fwktest_print error "«${__dir}» is not a directory."
        else
            __test_dirs+=("${__dir}")
        fi
    done
}

function fwktest_evaluate() {
    local __test_filename=${1:-"test_"} # If no null, test only this file

    local -a __test_files=()
    mapfile -t __test_files < <(printf "%s\n" "${__test_dirs[@]}" | xargs -I {} find "{}" -type f -name "${__test_filename}*")

    if (( ${#__test_files[@]} == 0 ))
    then
        fwktest_print error "No test found."
    fi

    local -i __time_spent=0
    local __test_file __filename __test_dir
    for (( __index=0; __index<${#__test_files[@]}; __index+=1 ))
    do
        __test_file="${__test_files[${__index}]}"
        __filename="$(echo "${__test_file}" | awk -F '/' '{print $NF}')"
        __test_dir="$(echo "${__test_file}" | grep -o '.*/')"

        # Grep all test functions
        local -a __test_funcs=()
        mapfile -t __test_funcs < <(grep -o -E 'test_[a-zA-Z_]+\(\)' "${__test_file}" | sed 's/()//g')
        if [[ ${#__test_funcs} -eq 0 ]]
        then
            echo "No tests found for <${__test_file}>"
            continue
        fi

        printf "Test #%d\nFile : %s\n" ${__index} "${__filename}"

        # Move to test directory to avoid relative paths sourcing errors
        pushd "${__test_dir}" &> /dev/null

        # Source functions
        source "./${__filename}"

        local -i __pre_exec_test_file_time=__time_spent
        # counters declared on fwktest_assertions
        # shellcheck disable=SC2154
        local -i __pre_exec_test_file_asserts=${__total_asserts_count} \
                 __pre_exec_test_file_fails=${__total_fails_count}
        for __fwktest_func in "${__test_funcs[@]}"
        do
            local -i __pre_call_asserts=${__total_asserts_count}
            local -i __pre_call_failed_asserts=${__total_fails_count}
            local -i __pre_call_time=${EPOCHREALTIME/./}

            # Calling the function
            ${__fwktest_func}

            local -i __post_call_time=${EPOCHREALTIME/./}
            local -i __exec_time=$(( __post_call_time - __pre_call_time ))
            __time_spent+=__exec_time
            local __exec_time_float
            printf -v __exec_time_float "%.6f" "$( echo "${__exec_time} / 1000000" | bc -l )"

            local -i __func_asserts=$(( __total_asserts_count - __pre_call_asserts ))
            local -i __func_fails=$(( __total_fails_count - __pre_call_failed_asserts ))
            local -i __func_passes=$(( __func_asserts - __func_fails ))

            if (( __func_fails != 0 ))
            then
                fwktest_print failed "${__fwktest_func}" "${__func_passes}/${__func_asserts}" "${__exec_time_float}"
            else
                fwktest_print pass "${__fwktest_func}" "${__func_passes}/${__func_asserts}" "${__exec_time_float}"
            fi
        done

        local __test_file_time_spent_float
        printf -v __test_file_time_spent_float "%.6f" "$( echo "(${__time_spent} - ${__pre_exec_test_file_time}) / 1000000" | bc -l )"

        local -i __test_file_asserts=$(( __total_asserts_count - __pre_exec_test_file_asserts ))
        local -i __test_file_fails=$(( __total_fails_count - __pre_exec_test_file_fails ))
        local -i __test_file_passes=$(( __test_file_asserts - __test_file_fails ))

        fwktest_print status "${__filename}" "${__test_file_passes}/${__test_file_asserts}" "${__test_file_time_spent_float}"
        popd &> /dev/null
    done

    local __time_spent_float
    printf -v __time_spent_float "%.6f" "$( echo "${__time_spent} / 1000000" | bc -l )"

    if (( __total_fails_count == 0 ))
    then
        fwktest_print tests_passed "${__total_asserts_count}" "${__time_spent_float}"
    else
        local -i __passed_asserts_count=$(( __total_asserts_count - __total_fails_count ))
        fwktest_print tests_failed "${__passed_asserts_count}" "${__total_fails_count}" "${__total_asserts_count}" "${__time_spent_float}"
    fi
}
