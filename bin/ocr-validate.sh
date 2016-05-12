#!/bin/bash

# Default to the parent dir of this script. Overwritten by `make install`
SHAREDIR="$(readlink -f "$(dirname "$(readlink -f "$0")")/..")"
source "$SHAREDIR/lib.sh"

show_usage() {
    echo "Usage: $0 [-dhL] <schema> <file> [<resultsFile>]"
}

while getopts ":dhL" opt; do
    case "$opt" in
        d)
            let DEBUG+=1
            ;;
        L)
            echo "${XSD_SCHEMAS[@]}"
            exit 0
            ;;
        h)
            show_usage
            show_schemas
            exit 0
            ;;
        *)
            break
            ;;
    esac
done
shift $((OPTIND-1))

schema="$1"; shift
file="$1"; shift

if [[ -z "$schema" || -z "$file" ]];then
    show_usage
    echo "!! Not enough arguments !!"
    exit 100
fi

if [[ "$file" == "-" ]];then
    echo_err "Reading from STDIN"
else 
    file=$(readlink -f "$file")
    if [[ ! -e "$file" ]];then
        show_usage
        echo "!! No such file !!"
        exit 101
    fi
fi

if ! containsElement "$schema" "${XSD_SCHEMAS[@]}";then
    show_usage
    echo "!! No such schema: '$schema' !!"
    show_schemas
    exit 102
fi

exec_xsdv "$schema" "$file"
