#!/bin/sh

if [ "${0}" != "-bash" ]; then
    SCRIPT_NAME=`basename $0`
fi

CORES_HOME=$HOME/cores/

if [ -e $HOME/.nutch-config ]; then
    . $HOME/.nutch-config
fi

initialize() {
    export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
    check_crawldb $1 $2
    check_nutch $1 $3
}

check_params() {
    if [ "${1}" = "" ]; then
        echo "You must provide the core name (ex: ${SCRIPT_NAME} core_name)"
        exit 1
    fi
}

check_crawldb() {
    if [ ! -e "${2}" ]; then
        echo "The core named ${1} doesn't exist (${2})"
        exit 1
    fi
}

check_nutch() {
    if [ ! -e "${2}/bin/nutch" ]; then
        echo "Nutch installation doesn't exist for core ${1}"
        exit 1
    fi
}

check_status() {
    RET_CODE=$?
    if [ $RET_CODE -ne 0 ]; then
        exit $RET_CODE
    fi
}
