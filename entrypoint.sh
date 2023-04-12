#!/bin/bash
set -e

if [[ -z $MONITOR_FILE ]]; then
    echo "MONITOR_FILE can not be an empty string."
    exit 1
fi

container=$(docker ps --latest --quiet --filter "label=docker-irestarter")
if [[ -z $container ]]; then
    echo "No docker container with 'docker-irestarter' label could be found"
    exit 1
fi 

function process_restart() {
    else
        docker restart $container
        echo "docker restart sent to $container"
    fi
}

inotifywait --monitor --recursive --event close_write $MONITOR_FILE | while read; do process_restart; done
