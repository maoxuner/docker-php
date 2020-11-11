ARG PHP_TAG=cli-alpine

FROM php:${PHP_TAG}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN set -ex; \
    apk add --no-cache supervisor; \
    mkdir /etc/supervisor.d; \
    sed -i '/^;pidfile/ s/^;//' /etc/supervisord.conf; \
    sed -i '/^files\ =/ s/.*/files\ =\ \/etc\/supervisor\.ini\ \/etc\/supervisor\.d\/\*\.ini/' /etc/supervisord.conf

RUN set -ex; \
    apk add --no-cache \
        --virtual .build-deps \
        zlib-dev linux-headers \
        autoconf g++ make; \
    pecl install redis grpc swoole inotify; \
    docker-php-ext-enable redis grpc swoole inotify; \
    apk del --purge .build-deps \
        zlib-dev linux-headers \
        autoconf g++ make; \
    apk add --no-cache \
        libzip-dev bzip2-dev \
        libpng-dev libjpeg-turbo-dev freetype-dev \
        icu-dev; \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/; \
    docker-php-ext-install -j$(nproc) \
        opcache \
        mysqli pdo_mysql \
        zip bz2 \
        gd sockets \
        intl bcmath

COPY supervisor.ini /etc/supervisor.ini

CMD ["supervisord", "-n"]
