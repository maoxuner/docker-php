FROM php:7.2-fpm-alpine

LABEL maintainer="maoxuner@126.com"

RUN set -ex \
    && apk add --no-cache \
        libjpeg-turbo-dev libpng-dev freetype-dev \
        bzip2-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        mysqli pdo_mysql zip bz2 gd sockets
