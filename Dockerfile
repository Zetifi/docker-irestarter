FROM docker:20-cli

RUN apk add --no-cache inotify-tools bash

COPY entrypoint.sh .

CMD ["bash", "entrypoint.sh"]