# msg <message> <exit code if it is required>
function msg {
    echo -e "\n$1\n"
    if [ ! -z $2 ]; then exit $2; fi
    return 0
}

function error {
    msg "ERROR! $1" 1
}
