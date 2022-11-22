#!/bin/bash

inotifywait --monitor --event close_write $SSL_CERTFILE | while read; do docker restart $(docker ps --latest --quiet --filter "name=$SERVICE_TO_RESTART"); done
