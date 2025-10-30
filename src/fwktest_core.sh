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
        for __function in "${__test_func[@]}"
        do
            ${__function}
        done
        popd &> /dev/null
    done
}
