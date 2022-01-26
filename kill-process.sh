#!/bin/bash

set -e

# Usage function
function usage() {
    cat <<USAGE
    Usage: $0 [-p|--port-number <port number>] [-h|--help]
    Options:
        -p|--port-number:   The port number to kill.
                            Default: 7071
        -h|--help:          Show this message.
USAGE

    exit 1
}

# Set up arguments
port_number=7071

if [[ $# -eq 0 ]]; then
    port_number=7071
fi

while [[ "$1" != "" ]]; do
    case $1 in
    -p | --port-number)
        shift
        port_number=$1
        ;;

    -h | --help)
        usage
        exit 1
        ;;

    *)
        usage
        exit 1
        ;;
    esac

    shift
done

if [[ $port_number == "" ]]; then
    echo "Port number not set"
    usage

    exit 1
fi

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Killing the process currently holding the port ..."
process_id=$(sudo lsof -nP -i4TCP:$port_number | grep LISTEN | awk '{print $2}')

if [[ $process_id != "" ]]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Process ID: $process_id being killed ..."
    sudo kill -9 $process_id

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Process ID: $process_id has been killed. You can now run the app."
else
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] No process found to kill. You can now run the app."
fi
