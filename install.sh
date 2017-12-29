#!/bin/bash

set -e

PARAMETERS_COUNT=$#
MODE=standalone
WEB_ROOT_FOLDER=""
SHOW_HELP=false
HELP_MESSAGE="Usage: ./$(basename $0) [OPTION]
Script for installing and configuring letsencrypt certificates usage.
Maintainer: devops@onix-systems.com
Options:
    -m, --mode <mode>         Set script's mode
                                * standalone - run certbot in standalone mode.
                                * webroot    - use prepared webroot for verification specified DN.
    -r, --root <folder>       Set webroot folder to use for DN verification. Should be prepared manually.
    -d, --domain-name [dn]    List of domain names for implementing them into certificate.
    -h, --help                Show help

Examples:
    \$ ./$(basename $0) --mode standalone --dn staging.test.com
    \$ ./$(basename $0) -m weboot -r /var/www/html --dn staging.test.com
"

# msg <message> <exit code if it is required>
function msg {
    echo -e "\n$1\n"
    if [ ! -z $2 ]; then exit $2; fi
    return 0
}

function error {
    msg "ERROR! $1" 1
}

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -m|--mode)
            if [ "$(echo $2 | grep '^standalone$\|^webroot$')" != "" ]; then MODE="$2";
            else echo "ERROR! Unsupported mode. See help."; exit 1; fi
            shift
        ;;
        -r|--root)
            if [ -d "$2" ]; then
                WEB_ROOT_FOLDER=$2
            fi
            shift
        ;;
        -d|--domain-name)
            DN="$2";
            # Check if such name exist and resolved by nslookup
            shift
        ;;
        -h|--help)
            SHOW_HELP=true
        ;;
        *) # unknown option
            echo "ERROR! Unknown option. See help."
            exit 1
        ;;
    esac
shift
done

if [ "${SHOW_HELP}" == "true" ] || [ "${PARAMETERS_COUNT}" -eq 0 ]; then
    msg "${HELP_MESSAGE}" 0
fi

# Check root rights
if [ "$(id -u)" -ne 0 ]; then
    error "Administrative rights are required."
fi
