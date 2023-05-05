#!/bin/bash

# Default to the parent dir of this script. Overwritten by `make install`
SHAREDIR="$(readlink -f "$(dirname "$(readlink -f "$0")")/..")"
source "$SHAREDIR/lib.sh"

#{{{ show_usage ()
show_usage () {
    [[ "$#" -gt 0 ]] && logerr "$@"

    echo >&2 "Usage:
${0##*/} [OPTIONS] <schema> <file> [<resultsFile>]
${0##*/} [OPTIONS] -h|--help       Show this help, and exit
${0##*/} [OPTIONS] -v|--version    Show version, and exit
${0##*/} [OPTIONS] -L|--list       List available schemas, and exit

    Options:
        --debug   -d     Increase debug level by 1, can be repeated

"
    echo >&2 -e "\n${INDENT}Schemas:"
    show_schemas|sed "s/^/${INDENT}${INDENT}/"
    echo

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

    local schema="$1" file="$2"
    shift 2

    if [[ -z "$schema" ]];then
        show_usage "Must set 'schema'"
    elif [[ -z "${OCR_VALIDATORS[$schema]}" ]];then
        show_usage "No such schema '$schema'"
    fi

    if [[ -z "$file" ]];then
        show_usage "Must set 'file'"
    fi

    if [[ "$file" == "-" ]];then
        ((DEBUG > 1)) && loginfo "Reading from STDIN"
    else 
        file=$(readlink -f "$file")
        if [[ ! -e "$file" ]];then
            show_usage "No such file: '$file'"
        fi
    fi

    if [[ "${OCR_VALIDATORS[$schema]}" = *.xsd ]];then
        "exec_xsdv" "$schema" "$file"
    else
        source "${OCR_VALIDATORS[$schema]}" "$file"
    fi
}
#}}}

while [[ "$1" = -* ]]; do
    case "$1" in
        --debug|-d) let DEBUG+=1 ;;
        --list|-L) show_schemas|sed -e 's/\s*$//' -e 's/ \+/\n/g' ; exit 0 ;;
        --help|-h) show_usage ; exit 0 ;;
        --version|-v) show_version ; exit 0 ;;
        *) logerr "Unknown option '$1'" && show_usage && exit 1 ;;
    esac
    shift
done

if [[ -d "$SHAREDIR/venv" ]];then
    . "$SHAREDIR/venv/bin/activate"
fi

main "$@"
