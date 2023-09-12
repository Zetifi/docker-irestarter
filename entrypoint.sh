#!/bin/bash
set -euo pipefail

if [[ -z $MONITOR_FILE ]]; then
    echo "MONITOR_FILE can not be an empty string."
    exit 1
fi

CONTAINER=$(docker ps --latest --quiet --filter "label=$CONTAINER_LABEL")
if [[ -z $CONTAINER ]]; then
    echo "No docker container with '$CONTAINER_LABEL' label could be found"
    exit 1
fi 

function process_restart() {
    if [[ -n $SIGNAL ]]; then
        docker kill --signal=$SIGNAL $CONTAINER
        echo "docker kill signal $SIGNAL sent to $CONTAINER"
    else
        docker restart $CONTAINER
        echo "docker restart sent to $CONTAINER"
    fi
}

inotifywait --monitor --recursive --event close_write $MONITOR_FILE | while read; do process_restart; done
