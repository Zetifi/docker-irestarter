#!/bin/bash
set -e

if [[ -z $MONITOR_FILE ]]; then
    echo "MONITOR_FILE can not be an empty string."
    exit 1
fi

function process_restart() {
    if [[ $SIGHUP ]]; then
        container=$(docker ps --latest --quiet --filter "label=docker-irestarter-SIGHUP")
        docker kill --signal=SIGHUP $container
        echo "SIGHUP sent to $container for proccess $SIGHUP"
    else
        container=$(docker ps --latest --quiet --filter "label=docker-irestarter")
        docker restart $container
        echo "docker restart sent to $container"
    fi
}

inotifywait --monitor --recursive --event close_write $MONITOR_FILE | while read; do process_restart; done
