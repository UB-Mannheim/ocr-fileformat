#!/bin/bash

DEBUG=0

XSLT_SCRIPTS=($(cd "$SHAREDIR/xslt";  find -name '*.xsl' |sed 's,^./,,'|sed 's/\.xsl$//'|sort))
XSLT_IN=()
XSLT_OUT=()

SAXON_JAR="$SHAREDIR/vendor/saxon9he.jar"
SAXON_ARGS=()

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
        if ! containsElement "$in_fmt", "${XSLT_IN[@]}";then XSLT_IN+=($in_fmt);fi
        if ! containsElement "$out_fmt", "${XSLT_OUT[@]}";then XSLT_OUT+=($out_fmt);fi
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
    if [[ "$DEBUG" -gt 0 ]];then
        echo Executing "$SAXON" "${SAXON_ARGS[@]}"
    fi

    if [[ "$DEBUG" -gt 1 ]];then
        SAXON_ARGS+=('-t')
    fi

    java -jar "$SAXON_JAR" "$@"
}


exec_xsdv() {
    schema="$1"
    file="$1"
    cd "$XSD_VALIDATOR_DIR"
    if ((DEBUG > 0));then
        echo "PWD: '$PWD'"
        echo "./xsdv.sh '$SHAREDIR/xsd/${schema}.xsd' '$file'"
    fi
    exec ./xsdv.sh "$SHAREDIR/xsd/${schema}.xsd" "$file" "${XSD_ARGS[@]}"
}
