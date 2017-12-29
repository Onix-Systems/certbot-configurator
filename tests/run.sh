#!/bin/bash
# file: tests/run.sh

set -e

[ ! -z ${TEST_SCRIPT} ] || TEST_SCRIPT=../install.sh
TEST_SCRIPT_FULL_PATH=$(cd $(dirname ${TEST_SCRIPT}); pwd | tr '\r\n' '/'; echo $(basename ${TEST_SCRIPT}))

# Scripts possible options
STANDALONE_MODE=standalone
WEBROOT_MODE=webroot
FAKE_MODE=fake
DOMAIN_NAME=local.test.com
ENABLE_CHECK_MODE="export CHECK=true;"
DISABLE_CHECK_MODE="export CHECK=false;"
#
SUDO=sudo

# Check if ${TEST_SCRIPT} is available for testing
if [ ! -e "${TEST_SCRIPT}" ] || [ ! -x "${TEST_SCRIPT}" ]; then
    error "Can not be found script for testing! Was declared, that it is located by path: ${TEST_SCRIPT_FULL_PATH}; pwd).Please fix."
fi

test_application_without_root_rights() {
    ${ENABLE_CHECK_MODE}
    STDOUT=$(${TEST_SCRIPT} ${OPTIONS} -m ${STANDALONE_MODE})
    rtrn=$?
    assert_not_equals 0 ${rtrn} "Must be error without administrative rights."
    assert_equals "ERROR! Administrative rights are required." "${STDOUT}" "Checking root rights required failed."
}

test_application_with_root_rights() {
    ${ENABLE_CHECK_MODE}
    STDOUT=$(${SUDO} ${TEST_SCRIPT} -m ${STANDALONE_MODE})
    rtrn=$?
    assert_equals 0 ${rtrn} "Incorrect exit code by running application with root rights."
}

testing_mode_options_checking() {
  ${ENABLE_CHECK_MODE}
  STDOUT=$(${SUDO} ${TEST_SCRIPT} -m ${STANDALONE_MODE})
  rtrn=$?
  assert_equals 0 ${rtrn} "Incorrect exit code by running application in ${STANDALONE_MODE} mode."
  STDOUT=$(${SUDO} ${TEST_SCRIPT} -m ${WEBROOT_MODE})
  rtrn=$?
  assert_equals 0 ${rtrn} "Incorrect exit code by running application in ${WEBROOT_MODE} mode."
  STDOUT=$(${SUDO} ${TEST_SCRIPT} --mode ${WEBROOT_MODE})
  rtrn=$?
  assert_equals 0 ${rtrn} "Incorrect exit code by running application in ${WEBROOT_MODE} mode by using long option name --mode."
  STDOUT=$(${SUDO} ${TEST_SCRIPT} -m ${FAKE_MODE})
  rtrn=$?
  assert_equals "ERROR! Unsupported mode. See help." "${STDOUT}" "Incorrect message when it is specified incorrect mode."
}
