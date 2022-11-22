#!/bin/bash

inotifywait --monitor --event close_write $MONITOR_FILE | while read; do docker restart $(docker ps --latest --quiet --filter "label=docker-irestarter"); done
