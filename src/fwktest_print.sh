#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
PURPLE='\e[1;35m'
CYAN='\e[1;36m'
BLK='\e[0;0m'

# @brief for internal use only
function fwktest_print() {
    local color=${1^^}
    shift
    local arg1="${1}"
    local arg2="${2}"
    local arg3="${3}"
    case ${color} in
        FAIL)
            printf "${BLUE}[${RED} FAIL ${BLUE}]${BLK} ${PURPLE}%b${BLK}::${CYAN}%d${BLK} => %b\n" "${FUNCNAME[2]}" "${BASH_LINENO[1]}"  "${arg1}" >&2
            return 1
        ;;
        FAILED)
            printf "${BLUE}[${RED}FAILED${BLUE}]${BLK} ${PURPLE}%b${BLK} ${BLUE}(${YELLOW}%b${BLUE})${BLK}\n" "${arg1}" "${arg2}" >&2
        ;;
        PASS|PASSED)
            printf "${BLUE}[${GREEN}PASSED${BLUE}]${BLK} ${PURPLE}%b${BLK} ${BLUE}(${YELLOW}%b${BLUE})${BLK}\n" "${arg1}" "${arg2}" >&2
        ;;
        TESTS_FAILED)
            printf "${BLUE}[${RED}TESTS NOT PASSED${BLUE}]${BLK} ${GREEN}PASSED:${BLK} %b ${RED}FAILED:${BLK} %b ${YELLOW}TOTAL:${BLK} %b\n" "${arg1}" "${arg2}" "${arg3}" >&2
        ;;
        TESTS_PASSED)
            printf "${BLUE}[${GREEN}ALL TEST PASSED${BLUE}]${BLK}\n" >&2
        ;;
        STATUS)
            printf "${BLUE}[${CYAN}STATUS${BLUE}]${BLK} ${PURPL}%b${BLK} ${BLUE}(${YELLOW}%b${BLUE})${BLK}\n\n" "${arg1}" "${arg2}" >&2
        ;;
    esac
}

