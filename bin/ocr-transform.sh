#!/bin/bash

# Default to the parent dir of this script. Overwritten by `make install`
SHAREDIR="$(readlink -f "$(dirname "$(readlink -f "$0")")/..")"
source "$SHAREDIR/lib.sh"

show_usage() {
    echo "Usage: $0 [-dh] <input-fmt> <output-fmt> [<input> [<output>]] [-- <saxon_opts>]"
}
SAXON_ARGS=()

while getopts ":dhL" opt; do
    case "$opt" in
        d)
            let DEBUG+=1
            ;;
        L)
            echo "${XSLT_SCRIPTS[@]}"
            exit 0
            ;;
        h)
            show_usage
            show_input_formats
            show_output_formats
            exec_saxon -t |grep -v 'No source file'|grep -v 'Format:'
            exit 0
            ;;
        *)
            break
            ;;
    esac
done
shift $((OPTIND-1))

from="$1"
to="$2"
if [[ -z "$from" || -z "$to" ]];then
    show_usage
    echo "!! Not enough arguments !!"
    exit 1
fi
if ! containsElement "$from" "${XSLT_IN[@]}";then
    show_usage
    echo "!! Bad input format '$from' !!"
    show_input_formats
    exit 1
fi
if ! containsElement "$to" "${XSLT_OUT[@]}";then
    show_usage
    echo "!! Bad output format '$to' !!"
    show_output_formats
    exit 1
fi
SAXON_ARGS+=("-xsl:$SHAREDIR/xslt/${from}__${to}.xsl")
shift 2

# input
if [[ -z "$1" ]];then
    echo_err "Reading from STDIN"
    SAXON_ARGS+=('-s:-')
elif [[ "$1" == '--' ]];then
    shift
    while [[ ! -z "$1" ]];do
        SAXON_ARGS+=("$1")
        shift
    done
else
    SAXON_ARGS+=("-s:$1")
    shift;
fi

# output
if [[ "$1" == '--' ]];then
    shift
    while [[ ! -z "$1" ]];do
        SAXON_ARGS+=("$1")
        shift
    done
elif [[ ! -z "$1" ]];then
    SAXON_ARGS+=("-o:$1")
    shift;
else
    echo_err "Writing to STDOUT"
fi

# saxon_opts
if [[ "$1" == '--' ]];then
    shift
    while [[ ! -z "$1" ]];do
        SAXON_ARGS+=("$1")
        shift
    done
fi

# Run it
exec_saxon "${SAXON_ARGS[@]}"
