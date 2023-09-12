FROM docker:20-cli

ENV CONTAINER_LABEL=docker-irestarter \
    SIGNAL=""

RUN apk add --no-cache inotify-tools bash

COPY entrypoint.sh .

CMD ["bash", "entrypoint.sh"]