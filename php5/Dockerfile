ARG PHP_TAG=5-cli-alpine
ARG COMPOSER_TAG=2.2
FROM composer:${COMPOSER_TAG} AS composer
FROM php:${PHP_TAG}

LABEL org.opencontainers.image.authors="maoxuner@126.com"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories
RUN set -ex; \
    apk add --no-cache \
        postgresql-dev \
        libzip-dev bzip2-dev \
        libjpeg-turbo-dev libpng-dev freetype-dev \
        icu-dev \
        linux-headers; \
    docker-php-ext-configure gd --with-jpeg --with-freetype; \
    docker-php-ext-install -j$(nproc) \
        opcache pcntl bcmath sockets calendar \
        mysqli pdo_mysql \
        pdo_pgsql \
        zip bz2 \
        gd \
        intl; \
    apk del linux-headers

ARG REDIS_VERSION=4.3.0
ARG MONGODB_VERSION=1.7.5
RUN set -ex; \
    apk add --no-cache $PHPIZE_DEPS; \
    pecl install redis-${REDIS_VERSION}; \
    pecl install mongodb-${MONGODB_VERSION}; \
    docker-php-ext-enable redis mongodb; \
    apk del $PHPIZE_DEPS; \
    rm -rf /tmp/pear

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
