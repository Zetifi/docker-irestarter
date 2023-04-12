# docker-irestarter

Restart a docker container when a file is modified.

## How

This project combines `inotifywait` from `inotify-tools` with Docker to watch for a modification to a file and restart containers with a specific label.

For example, this image could be used in a docker-compose file to restart a container upon an update to an SSL certificate file, where the service is unable to handle this itself. In this case, you would configure the environment variable to monitor the certificate file.

## Example compose file
Read on, or [view an example project](example).

This example has been created based upon the docker compose CLI v2.

Set the file to monitor for changes as an environment variable.

This can also be set in a `.env` file in the same directory as the compose file.

***Note**: Environment variables set with `export` or another method take precedence over `.env`. Ensure to `unset MONITOR_FILE` if issues with `.env` are experienced.*

You should always ensure the irestarter container is running following a `docker-compose up`.

Alternatively, you can individually replace ${MONITOR_FILE} in the compose file with suitable values.
```
MONITOR_FILE=/file/to/monitor.txt
```

This snippet can be inserted into an existing compose file with minimal changes.
```yml
version: "3"
services:
  docker-irestarter:
    image: zetifi/docker-irestarter:latest
    restart: always
    volumes:
      - ${MONITOR_FILE}:${MONITOR_FILE}
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - MONITOR_FILE=${MONITOR_FILE}

  example-service:
    ...
    labels:
      - "docker-irestarter"
```

### Send a Linux Signal instead of container restart
Instead of restarting the container, it's possible to send a signal to a container.
Refer to the [signal(7)](https://man7.org/linux/man-pages/man7/signal.7.html) man-page for a list of standard Linux signals.

Note the `SIGHUP` signal passsed as an environment variable to the `docker-irestarter` container.
```yml
version: "3"
services:
  docker-irestarter:
    image: zetifi/docker-irestarter:latest
    restart: always
    volumes:
      - ${MONITOR_FILE}:${MONITOR_FILE}
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - MONITOR_FILE=${MONITOR_FILE}
      - SIGNAL=SIGHUP

  example-service:
    ...
    labels:
      - "docker-irestarter"
```
