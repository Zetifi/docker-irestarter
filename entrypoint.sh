#!/bin/bash
set -e

if [[ -z $MONITOR_FILE ]]; then
    echo "MONITOR_FILE can not be an empty string."
    exit 1
fi

function process_restart() {

    container=$(docker ps --latest --quiet --filter "label=docker-irestarter")

    if [[ $SIGNAL ]]; then
        docker kill --signal=$SIGNAL $container
        echo "docker kill signal $SIGNAL sent to $container"
    else
        docker restart $container
        echo "docker restart sent to $container"
    fi
}

inotifywait --monitor --recursive --event close_write $MONITOR_FILE | while read; do process_restart; done
