#!/bin/bash

# Default to the parent dir of this script. Overwritten by `make install`
SHAREDIR="$(readlink -f "$(dirname "$(readlink -f "$0")")/..")"
source "$SHAREDIR/lib.sh"

show_usage() {
    echo "Usage: $0 [-dh] <input-fmt> <output-fmt> [<input> [<output>]] [-- <saxon_opts>]"
}

while getopts ":dh" opt; do
    case "$opt" in
        d)
            let DEBUG+=1
            ;;
        h)
            show_usage
            show_input_formats
            show_output_formats
            exec_saxon -t
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
SAXON_ARGS+=("-xsl:$SHAREDIR/${from}__${to}.xsl")
shift 2

# input
if [[ -z "$1" ]];then
    echo "Reading from STDIN" >&2
    SAXON_ARGS+=('-s:-')
elif [[ "$1" == '--' ]];then
    shift
    SAXON_ARGS+=($@)
else
    SAXON_ARGS+=("-s:$1")
    shift;
fi

# output
if [[ "$1" == '--' ]];then
    shift
    SAXON_ARGS+=($@)
elif [[ ! -z "$1" ]];then
    SAXON_ARGS+=("-o:$1")
    shift;
else
    echo "Writing to STDOUT" >&2
fi

# saxon_opts
if [[ "$1" == '--' ]];then
    shift
    SAXON_ARGS+=($@)
fi

# Run it
exec_saxon "${SAXON_ARGS[@]}"
