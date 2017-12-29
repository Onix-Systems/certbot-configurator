OPTIONS="-m ${STANDALONE_MODE} -d ${DOMAIN_NAME}"

testAdministrativeRightsFails() {
    ${TEST_SCRIPT} ${OPTIONS} >${stdoutF} 2>${stderrF}
    rtrn=$?
    assertFalse "Script should retrun non 0 exit code." "[ ${rtrn} -eq 0]"
    assertTrue "Running script inside the unprivileged user has to cause error." "[ ${rtrn} -ne 0 ]"
}
