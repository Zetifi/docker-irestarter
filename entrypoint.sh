#!/bin/bash
set -e

function process_restart() {
    if [[ $SIGHUP ]]; then
        container=$(docker ps --latest --quiet --filter "label=docker-irestarter-SIGHUP")
        docker exec $container killall -SIGHUP $SIGHUP
        echo "SIGHUP sent to $container for proccess $SIGHUP"
    else
        container=$(docker ps --latest --quiet --filter "label=docker-irestarter")
        docker restart $container
        echo "docker restart sent to $container"
    fi
}

inotifywait --monitor --event close_write $MONITOR_FILE | while read; do process_restart; done