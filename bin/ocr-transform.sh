#!/bin/bash

# Default to the parent dir of this script. Overwritten by `make install`
SHAREDIR="$(readlink -f "$(dirname "$(readlink -f "$0")")/..")"
source "$SHAREDIR/lib.sh"

#{{{ show_usage ()
show_usage () {
    [[ "$#" -gt 0 ]] && logerr "$@"

    echo >&2 "Usage:
${0##*/} [OPTIONS] <from> <to> [<infile> [<outfile>]] [-- <script-args>]
${0##*/} [OPTIONS] <from> <to> --help-args Show script-args, and exit
${0##*/} [OPTIONS] -h|--help               Show this help, and exit
${0##*/} [OPTIONS] -v|--version            Show version, and exit
${0##*/} [OPTIONS] -L|--list               List available from/to, and exit

    Options:
        --debug   -d     Increase debug level by 1, can be repeated

"
    echo >&2 -e "\n${INDENT}Transformations:"
    show_transformations|sed "s/^/${INDENT}${INDENT}/"

    [[ "$#" -gt 0 ]] && exit 1
}
#}}}

#{{{ show_version ()
show_version () {
    echo "${0##*/} VERSION"
}
#}}}

#{{{ main ()
main () {
    # debug option -d -d to print all commands to the terminal
    if (( DEBUG > 1 ));then
        set -x
    fi

    local from="$1" to="$2" infile='-' outfile='-' transformer
    shift 2

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
    transformer=${OCR_TRANSFORMERS[${from}__${to}]}

    if [[ "$1" == '--help-args' ]];then
        if [[ "$transformer" = */gcv__hocr ]];then
            echo >&2 -e "${INDENT}Extra arguments: <width> <height>"
        elif [[ "$transformer" = */page__alto ]];then
            echo >&2 -e "${INDENT}page-to-alto options:"
            page-to-alto --help|sed '1,/^Options:/d;/--output-file/,$d' >&2
        elif [[ "$transformer" = */textract__page ]];then
            echo >&2 -e "${INDENT}textract2page arguments: <image-file>"
            echo >&2 -e "${INDENT}textract2page options:"
        else
            # xsl and other transformers both take arbitrary Saxon options
            show_saxon_options|sed "s/^/${INDENT}${INDENT}/"
        fi
        exit 0
    fi

    declare -a script_args

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
    optstate=$(set +o)
    set -o errexit
    if [[ "$transformer" = *.xsl ]];then
        script_args=("${script_args[@]}" "-xsl:$transformer")
        script_args=("${script_args[@]}" "-s:$infile")
        [[ "$outfile" != '-' ]] &&  script_args=("${script_args[@]}" "-o:$outfile")
        exec_saxon "${script_args[@]}"
    else
        script_args=("$infile" "$outfile" "${script_args[@]}")
        source "$transformer" "${script_args[@]}"
    fi
    eval "$optstate"
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
