#!/bin/bash
# file: tests/run.sh

set -e

[ ! -z ${TEST_SCRIPT} ] || TEST_SCRIPT=../install.sh
TEST_SCRIPT_FULL_PATH=$(cd $(dirname ${TEST_SCRIPT}); pwd | tr '\r\n' '/'; echo $(basename ${TEST_SCRIPT}))

# Scripts possible options
STANDALONE_MODE=standalone
WEBROOT_MODE=webroot
CHECK_MODE=check
DOMAIN_NAME=local.test.com
#
SUDO=sudo

# Check if ${TEST_SCRIPT} is available for testing
if [ ! -e "${TEST_SCRIPT}" ] || [ ! -x "${TEST_SCRIPT}" ]; then
    error "Can not be found script for testing! Was declared, that it is located by path: ${TEST_SCRIPT_FULL_PATH}; pwd).Please fix."
fi

test_usage_application_without_root_rights() {
    OPTIONS="-m ${CHECK_MODE}"
    STDOUT=$(${TEST_SCRIPT} ${OPTIONS})
    rtrn=$?
    assert_not_equals ${rtrn} 0 "Must be error without administrative rights."
    assert_equals "ERROR! Administrative rights are required." "${STDOUT}" "Checking root rights required failed."
}

test_usage_application_with_root_rights() {
    OPTIONS="-m ${CHECK_MODE}"
    STDOUT=$(${SUDO} ${TEST_SCRIPT} ${OPTIONS})
    rtrn=$?
    assert_equals ${rtrn} 0 "Incorrect exit code by running application with root rights."
}
