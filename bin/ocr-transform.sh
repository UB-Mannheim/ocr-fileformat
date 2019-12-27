#!/bin/bash

# Default to the parent dir of this script. Overwritten by `make install`
SHAREDIR="$(readlink -f "$(dirname "$(readlink -f "$0")")/..")"
source "$SHAREDIR/lib.sh"

#{{{ show_usage ()
show_usage () {
    [[ "$#" -gt 0 ]] && logerr "$@"

    echo >&2 "Usage: ${0##*/} [-dhLv] <from> <to> [<infile> [<outfile>]] [-- <script-args>]

    Options:
        --help    -h     Show this help
        --version -v     Show version
        --debug   -d     Increase debug level by 1, can be repeated
        --list    -L     List transformations"
    echo >&2 -e "\n${INDENT}Transformations:"
    show_transformations|sed "s/^/${INDENT}${INDENT}/"
    echo >&2 -e "\n${INDENT}Saxon options:"
    show_saxon_options|sed "s/^/${INDENT}${INDENT}/"

    [[ "$#" -gt 0 ]] && exit 1
}
#}}}

#{{{ show_version ()
show_version () {
    echo "${0##*/} $(git describe)"
}
#}}}

#{{{ main ()
main () {
    local from="$1" to="$2" infile='-' outfile='-' transformer
    shift 2
    declare -a script_args

    # Validate parameters
    if [[ -z "$from" ]];then
        show_usage "Must set 'from' parameter"
    elif [[ -z "$to" ]];then
        show_usage "Must set 'to' parameter"
    elif [[ -z "${OCR_TRANSFORMATIONS[$from]}" ]];then
        show_usage "No mapping from '$from'"
    else
        declare -a possible=(${OCR_TRANSFORMATIONS[$from]})
        if ! in_array "$to" "${possible[@]}";then
            show_usage "No mapping from '$from' to '$to'"
        fi
    fi

    # <infile>
    if [[ "$1" == '--' ]];then
        script_args+=("${@:2}")
        set --
    elif [[ -n "$1" ]];then
        infile="$1"
    fi
    shift

    # <outfile>
    if [[ "$1" == '--' ]];then
        script_args+=("${@:2}")
        set --
    elif [[ -n "$1" ]];then
        outfile="$1"
    fi
    shift;

    # <script-args>
    if [[ "$1" == '--' ]];then
        script_args+=("${@:2}")
    fi

    if (( DEBUG > 0 ));then
        [[ "$infile" = '-' ]] && logdebug "Reading from STDIN"
        [[ "$outfile" = '-' ]] && logdebug "Writing to STDOUT"
    fi

    # Run it
    transformer=${OCR_TRANSFORMERS[${from}__${to}]}
    if [[ "$transformer" = *.xsl ]];then
        script_args=("${script_args[@]}" "-xsl:$transformer")
        script_args=("${script_args[@]}" "-s:$infile")
        [[ "$outfile" != '-' ]] &&  script_args=("${script_args[@]}" "-o:$outfile")
        exec_saxon "${script_args[@]}"
    else
        script_args=("${script_args[@]}" "$infile")
        script_args=("${script_args[@]}" "$outfile")
        "$transformer" "${script_args[@]}"
    fi
}
#}}}

while [[ "$1" = -* ]]; do
    case "$1" in
        -d|--debug) let DEBUG+=1 ;;
        -L|--list) show_transformations ; exit 0 ;;
        -h|--help) show_usage ; exit 0 ;;
        -v|--version) show_version ; exit 0 ;;
        *) logerr "Unknown option '$1'" && show_usage && exit 1 ;;
    esac
    shift
done

main "$@"
