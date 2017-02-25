#!/bin/bash

#{{{ Logging
if [[ -n "$COLORTERM" || "$TERM" = *color* || "$TERM" = xterm* ]];then
    COLOR_ERROR="\033[1;31m"
    COLOR_INFO="\033[1;32m"
    COLOR_DEBUG="\033[1;34m"
    COLOR_DEFAULT="\033[0m"
fi
# shellcheck disable=SC2048
logerr () {
    local IFS=$'\n'
    for line in $*;do
        echo -e "${COLOR_DEFAULT}[${COLOR_ERROR}ERROR${COLOR_DEFAULT}] $line" >&2
    done
}
loginfo () { echo -e "${COLOR_DEFAULT}[${COLOR_INFO}INFO${COLOR_DEFAULT}] $*" >&2; }
logdebug () { echo -e "${COLOR_DEFAULT}[${COLOR_DEBUG}DEBUG${COLOR_DEFAULT}] $*" >&2; }
#}}}

if [[ -z "$SHAREDIR" || ! -d "$SHAREDIR" ]];then
    logerr "Set \$SHAREDIR before sourcing $0"
    exit 1
fi

#{{{ utils (in_array)
# utility function to find the first pos param in the rest pos params
in_array () {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}
#}}}

#{{{ Global vars
export DEBUG=0
export INDENT="    "
# Mapping 'fmt' -> 'fmt2 fmt3 fmt4'
declare -Ax OCR_TRANSFORMATIONS=()
# Mapping 'fmt' -> '/path-to-xslt-or-transform-script'
declare -Ax OCR_TRANSFORMERS=()
# Mapping 'fmt' -> '/path-to-xsd-or-validate-script'
declare -Ax OCR_VALIDATORS=()
#}}}

#{{{ Set up validation and transformation formats
# setup_transformations ()
setup_transformations () {
    declare -a transformers=($(
        find -L "$SHAREDIR/xslt" "$SHAREDIR/script/transform" \
            ! -type d \( -name '*.xsl' -or -perm -005 \) \
        ))
    local in_fmt out_fmt
    for path in "${transformers[@]}";do
        fmt=${path##*/}
        fmt=${fmt%.*}
        OCR_TRANSFORMERS[$fmt]="$path"
        in_fmt=${fmt%%__*}
        out_fmt=${fmt##*__}
        if [[ -z "${OCR_TRANSFORMATIONS[$in_fmt]}" ]];then
            OCR_TRANSFORMATIONS[$in_fmt]="$out_fmt"
        else
            OCR_TRANSFORMATIONS[$in_fmt]+=" $out_fmt"
        fi
    done
}

# setup_validations ()
setup_validations () {
    declare -a validators=($(
        find -L "$SHAREDIR/xsd" "$SHAREDIR/script/validate" \
            ! -type d \( -name '*.xsd' -or -perm -005 \) \
            |sort))
    local path fmt
    for path in "${validators[@]}";do
        fmt=${path##*/}
        fmt=${fmt%.*}
        OCR_VALIDATORS[$fmt]="$path"
    done
}

setup () {
    setup_transformations
    setup_validations
}
setup
#}}}

#{{{ List transformations, validations, saxon options
# show_schemas ()
show_schemas() {
    local schema schemagroup
    declare -a sorted=($(IFS=$'\n'; echo "${!OCR_VALIDATORS[*]}"|sort -t- -nk2  -k1))
    for schema in "${sorted[@]}";do
        [[ -n "$schemagroup" && "$schemagroup" != ${schema%%-*} ]] && echo
        echo -n "$schema "
        schemagroup=${schema%%-*}
    done
}

# show_transformations ()
show_transformations() {
    local in_fmt out_fmt
    for in_fmt in "${!OCR_TRANSFORMATIONS[@]}";do
        declare -a out_fmts=(${OCR_TRANSFORMATIONS[$in_fmt]})
        for out_fmt in "${out_fmts[@]}";do
            echo "${in_fmt} ${out_fmt}";
        done
    done|sort
}

# show_saxon_options ()
show_saxon_options () {
    exec_saxon -t 2>&1|sed -e '0,/No source file/ d' -e '/Format:/ d'
}
#}}}

#{{{ run saxon / xsd-validator (xsdv.sh)
# exec_saxon ()
exec_saxon() {
    (( DEBUG > 0 )) && loginfo Executing "java -jar $SAXON_JAR" "$@"
    (( DEBUG > 1 )) && SAXON_ARGS+=('-t')
    java -jar "$SHAREDIR/vendor/saxon9he.jar" "$@"
}

# exec_xsdv ()
exec_xsdv() {
    local schema="$1" file="$2"
    cd "$SHAREDIR/vendor/xsd-validator"
    if ((DEBUG > 0));then
        loginfo "PWD: '$PWD'"
        loginfo "./xsdv.sh '$SHAREDIR/xsd/${schema}.xsd' '$file'"
    fi
    ./xsdv.sh "$SHAREDIR/xsd/${schema}.xsd" "$file"
}
#}}}
