#!/bin/bash

#
# Maintainer: devops@onix-systems.com
# https://onix-systems.com
#

set -e

PARAMETERS_COUNT=$#
MODE=standalone
WEB_ROOT_FOLDER=""
SHOW_HELP=false
CHECK_ONLY=false
DNS_SERVER=8.8.8.8
MODE=webroot
CERTBOT_OPTIONS="--agree-tos"
SKIP_CERTIFICATE_RETRIEVING=false
COMMAND=""
CROND_FOLDER="/etc/cron.d/"
CRON_TASK="reload"
SCRIPT_PATH=/usr/local/sbin/check_certs.sh
[ -z "${DRY_RUN}" ] || DRY_RUN=false
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
    -c, --command <command>   Command that can be used for reload application to apply new certificates.

Examples:
    \$ ./$(basename $0) --mode standalone --dn staging.test.com
    \$ ./$(basename $0) -m weboot -r /var/www/html --dn staging.test.com
"

#
# --check-only is a hidden option, is used only for testing functionality
#

cd $(dirname $0)
source common.inc

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -m|--mode)
            if [ "$(echo $2 | grep '^standalone$\|^webroot$')" != "" ]; then MODE="$2";
            else error "Unsupported mode. See help.";
            fi
            shift
        ;;
        -r|--root)
            if [ -d "$2" ]; then
                WEB_ROOT_FOLDER=$2
            else error "Specified folder does not exist. Please check.";
            fi
            shift
        ;;
        -d|--domain-name)
            DN="$2";
            CRON_TASK="${CRON_TASK}-$(echo ${DN} | cut -d '.' -f 1)"
            shift
        ;;
        -m|--email)
            CERTBOT_OPTIONS="${CERTBOT_OPTIONS} -m $2"
            shift
        ;;
        -h|--help)
            SHOW_HELP=true
        ;;
        --check-only)
            CHECK_ONLY=true
        ;;
        --skip-certificate-retrieving)
            SKIP_CERTIFICATE_RETRIEVING=true
        ;;
        -c|--command)
            COMMAND=$2
            shift
        ;;
        *) # unknown option
            error "Unknown option. See help."
        ;;
    esac
shift
done

if [ "${SHOW_HELP}" == "true" ] || [ "${PARAMETERS_COUNT}" -eq 0 ]; then
    msg "${HELP_MESSAGE}" 0
fi

if [ -z "${DN}" ]; then
    error "Domain name is required. See help."
elif [ "$(check_domain_name ${DN})" != 0 ]; then
    error "Was defined incorrect domain name."
fi

if [ "${MODE}" == "webroot" ]; then
    # Check required options
    if [ -z "${WEB_ROOT_FOLDER}" ]; then
        error "The mode [ webroot ] requires --root option."
    fi
    # Generate certbot options
    CERTBOT_OPTIONS="certonly --webroot --webroot-path ${WEB_ROOT_FOLDER} -d ${DN} ${CERTBOT_OPTIONS}"
elif [ "${MODE}" == "standalone" ]; then
    #
    # TODO. Process generating certbot options for standalone mode
    #
    :
fi

# Check root rights
if [ "$(id -u)" -ne 0 ]; then
    error "Administrative rights are required."
fi

if [ "${CHECK_ONLY}" == "true" ]; then
    exit 0
fi
# Installing certbot and other dependencies
msg "Installing dependencies"

apt-get update -qq
apt-get install -qq --yes software-properties-common &> /dev/null
add-apt-repository --yes --update ppa:certbot/certbot &> /dev/null
apt-get install -qq --yes certbot &> /dev/null

echo "Adding cron task for reloading service, that uses this ceritificate"
if [ ! -z "${COMMAND}" ]; then
cat << EOF > ${CROND_FOLDER}/${CRON_TASK}
# Command that will help to apply new certificate to use by domain name:
# ${DN}
0 5 * * 1 root ${COMMAND}
EOF
fi

if [ "${SKIP_CERTIFICATE_RETRIEVING}" == "false" ]; then
    certbot ${CERTBOT_OPTIONS}
else
    msg "Skipping the retrieving of certificate. For testing purpose only."
fi
