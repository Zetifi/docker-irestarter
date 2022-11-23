# docker-irestarter

Restart a docker container when a file is modified.

## How

This project combines `inotifywait` from `inotify-tools` with Docker to watch for a modification to a file and restart containers with a specific label.

For example, this image could be used in a docker-compose file to restart a container upon an update to an SSL certificate file, where the service is unable to handle this itself. In this case, you would configure the environment variable to monitor the certificate file.

## Example compose file
Set the file to monitor for changes as an environment variable.
```
MONITOR_FILE=/file/to/monitor.txt
```

This snippet can be inserted into an existing compose file with minimal changes.
```yml
version: "3"
services:
  docker-irestarter:
    image: Zetifi/docker-irestarter:latest
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
<!--
### Publishing

Notes for building and publishing
```bash
docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag zetifi/docker-irestarter:latest .
```

### Full working example

Dockerfile.example-service
```yml
FROM alpine:latest

RUN touch example.log

CMD ["tail", "-f", "example.log"]
```

docker-compose.yml
```yml
version: "3"
services:
  docker-irestarter:
    build:
      context: .
    restart: always
    volumes:
      - ${MONITOR_FILE}:${MONITOR_FILE}
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - MONITOR_FILE=${MONITOR_FILE}

  example-service:
    build:
      context: .
      dockerfile: Dockerfile.example-service
    labels:
      - "docker-irestarter"
```
-->