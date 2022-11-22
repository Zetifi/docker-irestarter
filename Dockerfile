FROM docker:20-cli

RUN apk add --no-cache inotify-tools bash

COPY entry-point.sh .

CMD ["bash", "entry-point.sh"]