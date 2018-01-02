[ -z "${OUTPUT_WITH_NEW_LINE}" ] || OUTPUT_WITH_NEW_LINE=false

# msg <message> <exit code if it is required>
function msg {
    if [ "${OUTPUT_WITH_NEW_LINE}" == true ]; then
        echo -e "\n$1\n"
    else
        echo "$1"
    fi
    if [ ! -z $2 ]; then exit $2; fi
    return 0
}

function error {
    msg "ERROR! $1" 1
}

function check_domain_name {
    set +e
    host $1 &> /dev/null || getent hosts $1 &> /dev/null
    echo $?
    set -e
}
