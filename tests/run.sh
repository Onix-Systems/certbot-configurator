#!/bin/bash
# file: tests/run.sh

cd $(dirname $0)
source ../common.inc

[ ! -z ${SHUNIT_PATH} ] || SHUNIT_PATH=./shunit2
[ ! -z ${TEST_SCRIPT} ] || TEST_SCRIPT=../install.sh
TEST_SCRIPT_FULL_PATH=$(cd $(dirname ${TEST_SCRIPT}); pwd | tr '\r\n' '/'; echo $(basename ${TEST_SCRIPT}))
HELP_MESSAGE="Tool for running unit tests against ${TEST_SCRIPT_FULL_PATH}
Usage: $ export SHUNIT_PATH=/shunit/shunit2
       $ ./run.sh"

# Scripts possible options
STANDALONE_MODE=snadalone
WEBROOT_MODE=webroot
DOMAIN_NAME=local.test.com
#
SUDO=sudo

# Check if shunit is available in local environment
if [ -z "${SHUNIT_PATH}" ] || [ ! -e "${SHUNIT_PATH}" ] || [ ! -x "${SHUNIT_PATH}" ]; then
    msg "${HELP_MESSAGE}"
    error "Can not be found shunit! Please fix."
fi

# Check if ${TEST_SCRIPT} is available for testing
if [ ! -e "${TEST_SCRIPT}" ] || [ ! -x "${TEST_SCRIPT}" ]; then
    error "Can not be found script for testing! Was declared, that it is located by path: ${TEST_SCRIPT_FULL_PATH}; pwd).Please fix."
fi

echo "Running unit tests against $(basename $TEST_SCRIPT)"

source test_administrative_rights.inc

source ${SHUNIT_PATH}
