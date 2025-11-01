#!/bin/bash

__RED='\e[1;31m'
__GREEN='\e[1;32m'
__YELLOW='\e[1;33m'
__BLUE='\e[1;34m'
__PURPLE='\e[1;35m'
__CYAN='\e[1;36m'
__BLK='\e[0;0m'

# @brief for internal use only
function fwktest_print() {
    local color=${1^^}
    shift
    case ${color} in
        FAIL)
            printf "${__BLUE}[${__RED} FAIL ${__BLUE}]${__BLK} ${__PURPLE}%b${__BLK}::${__CYAN}%d${__BLK} => %b\n" "${FUNCNAME[2]}" "${BASH_LINENO[1]}"  "${1}" >&2
            return 1
        ;;
        FAILED)
            printf "${__BLUE}[${__RED}FAILED${__BLUE}]${__BLK} ${__PURPLE}%b${__BLK} ${__BLUE}(${__YELLOW}%b${__BLUE})${__BLK}\n" "${1}" "${2}" >&2
        ;;
        PASS|PASSED)
            printf "${__BLUE}[${__GREEN}PASSED${__BLUE}]${__BLK} ${__PURPLE}%b${__BLK} ${__BLUE}(${__YELLOW}%b${__BLUE})${__BLK}\n" "${1}" "${2}" >&2
        ;;
        TESTS_FAILED)
            printf "${__BLUE}[${__RED}TESTS NOT PASSED${__BLUE}]${__BLK} ${__GREEN}PASSED:${__BLK} %b ${__RED}FAILED:${__BLK} %b ${__YELLOW}TOTAL:${__BLK} %b ${__BLUE}Time: ${__BLK}%.3f seconds\n" "${1}" "${2}" "${3}" ${4} >&2
        ;;
        TESTS_PASSED)
            printf "${__BLUE}[${__GREEN}ALL TESTS PASSED${__BLUE}]${__BLK} ${__BLUE}Time: ${__BLK}%.3f seconds\n" ${1} >&2
        ;;
        STATUS)
            printf "${__BLUE}[${__CYAN}STATUS${__BLUE}]${__BLK} %b ${__BLUE}(${__YELLOW}%b${__BLUE})${__BLK}\n\n" "${1}" "${2}" >&2
        ;;
    esac
}

