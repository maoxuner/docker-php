ARG PHP_TAG=8.2.2-cli-alpine
ARG ROADRUNNER_TAG=2.12.2
ARG COMPOSER_TAG=2

FROM spiralscout/roadrunner:${ROADRUNNER_TAG} as roadrunner
FROM composer:${COMPOSER_TAG} as composer
FROM php:${PHP_TAG}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories

RUN set -ex; \
    apk add --no-cache \
        postgresql-dev \
        libzip-dev bzip2-dev \
        libpng-dev libjpeg-turbo-dev freetype-dev \
        linux-headers \
        icu-dev; \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/; \
    docker-php-ext-install -j$(nproc) \
        opcache pcntl \
        mysqli pdo_mysql pdo_pgsql \
        zip bz2 \
        gd sockets \
        intl bcmath; \
    apk del linux-headers

ARG REDIS_VERSION=5.3.7
ARG GRPC_VERSION=1.51.1
ARG PROTOBUF_VERSION=3.21.12
ARG SWOOLE_VERSION=5.0.1
RUN set -ex; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    # redis
    mkdir /tmp/redis; \
    curl -sfL https://minio.fat4.cn/archive/pecl.php.net/get/redis-${REDIS_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/redis; \
    docker-php-ext-install -j$(nproc) /tmp/redis; \
    rm -rf /tmp/redis; \
    # grpc
    mkdir /tmp/grpc; \
    curl -sfL https://minio.fat4.cn/archive/pecl.php.net/get/grpc-${GRPC_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/grpc; \
    apk add --no-cache linux-headers; \
    CPPFLAGS="-Wno-maybe-uninitialized" docker-php-ext-install -j$(nproc) /tmp/grpc; \
    apk del linux-headers; \
    rm -rf /tmp/grpc; \
    # protobuf
    mkdir /tmp/protobuf; \
    curl -sfL https://minio.fat4.cn/archive/pecl.php.net/get/protobuf-${PROTOBUF_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/protobuf; \
    docker-php-ext-install -j$(nproc) /tmp/protobuf; \
    rm -rf /tmp/protobuf; \
    # swoole
    mkdir /tmp/swoole; \
    curl -sfL https://minio.fat4.cn/archive/pecl.php.net/get/swoole-${SWOOLE_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/swoole; \
    apk add --no-cache openssl-dev curl-dev; \
    docker-php-ext-configure /tmp/swoole --enable-openssl --enable-swoole-curl; \
    docker-php-ext-install -j$(nproc) /tmp/swoole; \
    rm -rf /tmp/swoole; \
    apk del .build-deps $PHPIZE_DEPS

COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
