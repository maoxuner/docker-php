ARG PHP_TAG=8-cli-alpine
ARG COMPOSER_TAG=2
FROM composer:${COMPOSER_TAG} AS composer
FROM php:${PHP_TAG}

LABEL org.opencontainers.image.authors="maoxuner@126.com"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories
RUN set -ex; \
    apk add --no-cache \
        git \
        postgresql-libs postgresql-dev \
        libzip libzip-dev bzip2 bzip2-dev \
        libjpeg-turbo libjpeg-turbo-dev libpng freetype freetype-dev \
        icu-data-full icu-libs icu-dev \
        linux-headers; \
    docker-php-ext-configure gd --with-jpeg --with-freetype; \
    docker-php-ext-install -j$(nproc) \
        opcache pcntl bcmath sockets calendar \
        mysqli pdo_mysql \
        pdo_pgsql \
        zip bz2 \
        gd exif \
        intl; \
    apk del linux-headers  \
        icu-dev \
        libjpeg-turbo-dev freetype-dev \
        libzip-dev bzip2-dev \
        postgresql-dev

ARG REDIS_VERSION=6.3.0
ARG MONGODB_VERSION=2.1.4
RUN set -ex; \
    apk add --no-cache $PHPIZE_DEPS openssl-dev; \
    pecl install redis-${REDIS_VERSION}; \
    pecl install mongodb-${MONGODB_VERSION}; \
    docker-php-ext-enable redis mongodb; \
    apk del $PHPIZE_DEPS openssl-dev; \
    rm -rf /tmp/pear

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
