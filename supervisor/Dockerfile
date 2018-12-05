FROM maoxuner/php:7.2-fpm-alpine

LABEL maintainer="maoxuner@126.com"

RUN set -ex \
    && apk add --no-cache \
        supervisor

COPY start.sh /usr/local/bin/

CMD ["start.sh"]
