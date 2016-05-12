#!/bin/bash

if [[ -z "$SHAREDIR" || ! -d "$SHAREDIR" ]];then
    echo_err "!! Set \$SHAREDIR before sourcing $0 !!"
    exit 1
fi

DEBUG=0

XSLT_SCRIPTS=($(cd "$SHAREDIR/xslt";  find -name '*.xsl' |sed 's,^./,,'|sed 's/\.xsl$//'|sort))
XSLT_IN=()
XSLT_OUT=()

SAXON_JAR="$SHAREDIR/vendor/saxon9he.jar"

XSD_VALIDATOR_DIR="$SHAREDIR/vendor/xsd-validator"
XSD_SCHEMAS=($(cd "$SHAREDIR/xsd"; find -name '*.xsd'|sort|sed 's/\.xsd//'|sed 's,./, ,'))
XSD_ARGS=()

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

show_schemas() {
    echo -e "Schemas:"
    local schema
    for schema in "${XSD_SCHEMAS[@]}";do
        echo "  - $schema"
    done
}

setupFormats() {
    local in_fmt out_fmt
    for fmt in "${XSLT_SCRIPTS[@]}";do
        in_fmt="${fmt//__*/}"
        out_fmt="${fmt//*__/}"
        if ! containsElement "$in_fmt" "${XSLT_IN[@]}";then XSLT_IN+=($in_fmt);fi
        if ! containsElement "$out_fmt" "${XSLT_OUT[@]}";then XSLT_OUT+=($out_fmt);fi
    done
}
setupFormats

show_input_formats() {
    echo "Input formats:"
    for i in "${XSLT_IN[@]}";do echo " - ${i}"; done
}

show_output_formats() {
    echo "Output formats:"
    for i in "${XSLT_OUT[@]}";do echo " - ${i}"; done
}

exec_saxon() {
    SAXON_ARGS=("$@")
    if [[ "$DEBUG" -gt 0 ]];then
        echo_err Executing "java -jar $SAXON_JAR" "${SAXON_ARGS[@]}"
    fi

    if [[ "$DEBUG" -gt 1 ]];then
        SAXON_ARGS+=('-t')
    fi

    java -jar "$SAXON_JAR" "${SAXON_ARGS[@]}"
}


exec_xsdv() {
    schema="$1"
    file="$2"
    cd "$XSD_VALIDATOR_DIR"
    if ((DEBUG > 0));then
        echo_err "PWD: '$PWD'"
        echo_err "./xsdv.sh '$SHAREDIR/xsd/${schema}.xsd' '$file'"
    fi
    ./xsdv.sh "$SHAREDIR/xsd/${schema}.xsd" "$file"
}

echo_err() {
    echo "$@" >&2;
}
