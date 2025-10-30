#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
PURPLE='\e[1;35m'
CYAN='\e[1;36m'
BLK='\e[0;0m'

function fwktest_print() {
    local color=${1}
    shift
    local messsage="$@"
    case ${color} in
        fail)
            printf "${BLUE}[${RED}FAIL${BLUE}]${BLK} ${PURPLE}%b${BLK}::${CYAN}%d${BLK} => %b\n" "${FUNCNAME[2]}" "${BASH_LINENO[1]}"  "${messsage}" >&2
            return 1
        ;;
        ok)
            printf "${BLUE}[${GREEN}OK${BLUE}]${BLK} %b\n" "${messsage}" >&2
        ;;
        info)
            printf "${BLUE}[${CYAN}INFO${BLUE}]${BLK} %b\n" "${messsage}" >&2
        ;;
    esac
}

