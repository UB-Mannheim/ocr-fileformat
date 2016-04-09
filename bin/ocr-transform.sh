#!/bin/bash

SHAREDIR="."
JAR="$SHAREDIR/saxon9he.jar"
SAXON="java -jar $JAR"
SAXON_ARGS=()
DEBUG=0

show_usage() {
    echo "Usage: $0 [-dl] <input-fmt> <output-fmt> [<input> [<output>]] [-- <saxon_opts>]"
}

show_input_formats() {
    echo "Input formats:"
    echo "  - 'alto'"
    echo "  - 'hocr'"
}

show_output_formats() {
    echo "Output formats:"
    echo "  - 'alto2.0'"
    echo "  - 'alto2.1'"
    echo "  - 'hocr'"
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
            $SAXON -t
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
if [[ "$from" != 'alto' && "$from" != 'hocr' ]];then
    show_usage
    echo "!! Bad input format '$from' !!"
    show_input_formats
    exit 1
fi
if [[ "$to" != 'alto2.0' && "$to" != 'alto2.1' && "$to" != 'hocr' ]];then
    show_usage
    echo "!! Bad output format '$to' !!"
    show_output_formats
    exit 1
fi
SAXON_ARGS+=("-xsl:$SHAREDIR/${from}2${to}.xsl")
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

# -d
if [[ "$DEBUG" -gt 0 ]];then
    echo Executing "$SAXON" "${SAXON_ARGS[@]}"
fi

# -dd
if [[ "$DEBUG" -gt 1 ]];then
    SAXON_ARGS+=('-t')
fi

# Run it
$SAXON "${SAXON_ARGS[@]}"
