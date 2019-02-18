ARG PHP_TAG=7.3-fpm-alpine

FROM maoxuner/php:${PHP_TAG}

RUN set -ex \
    && apk add --no-cache \
        supervisor \
        nginx \
    && mkdir -p /etc/supervisor.d \
    && sed -i '/^;pidfile/ s/^;//' /etc/supervisord.conf \
    && mkdir -p /run/nginx \
    && ln -s /dev/sdtout /var/log/nginx/access.log \
    && ln -s /dev/sdtout /var/log/nginx/error.log

COPY start.sh /usr/local/bin/

EXPOSE 80 443

CMD ["start.sh"]
