#!/bin/bash
# file: tests/run.sh

cd $(dirname $0)
source ../common.inc

[ ! -z ${SHUNIT_COMMAND} ] || SHUNIT_COMMAND=./shunit2
[ ! -z ${TEST_SCRIPT} ] || TEST_SCRIPT=../install.sh
TEST_SCRIPT_FULL_PATH=$(cd $(dirname ${TEST_SCRIPT}); pwd | tr '\r\n' '/'; echo $(basename ${TEST_SCRIPT}))
HELP_MESSAGE="Tool for running unit tests against ${TEST_SCRIPT_FULL_PATH}
Usage: $ ./run.sh"

# Scripts possible options
STANDALONE_MODE=snadalone
WEBROOT_MODE=webroot
DOMAIN_NAME=local.test.com
#
SUDO=sudo

# Check if shunit is available in local environment
if [ -z "${SHUNIT_COMMAND}" ] || [ -z "$(which ${SHUNIT_COMMAND})" ]; then
    msg "${HELP_MESSAGE}"
    error "Can not be found ${SHUNIT_COMMAND:-shunit}! Please fix."
fi

# Check if ${TEST_SCRIPT} is available for testing
if [ ! -e "${TEST_SCRIPT}" ] || [ ! -x "${TEST_SCRIPT}" ]; then
    error "Can not be found script for testing! Was declared, that it is located by path: ${TEST_SCRIPT_FULL_PATH}; pwd).Please fix."
fi

msg "Running unit tests against $(basename $TEST_SCRIPT)"

testAdministrativeRights() {
    OPTIONS="-m ${STANDALONE_MODE} -d ${DOMAIN_NAME}"
    ${TEST_SCRIPT} ${OPTIONS}
    rtrn=$?
    assertTrue "Running script inside the unprivileged user has to cause error." "[ ${rtrn} -ne 0  ]"
}

. ${SHUNIT_COMMAND}
