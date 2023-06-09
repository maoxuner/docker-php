ARG PHP_TAG=8.2.7-cli-alpine
ARG COMPOSER_TAG=2

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
ARG MONGODB_VERSION=1.15.3
ARG SWOOLE_VERSION=5.0.3
RUN set -ex; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    # redis
    mkdir /tmp/redis; \
    curl http://upyun.fat4.cn/archives/pecl.php.net/get/redis-${REDIS_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/redis; \
    docker-php-ext-install -j$(nproc) /tmp/redis; \
    rm -rf /tmp/redis; \
    # mongodb
    mkdir /tmp/mongodb; \
    curl http://upyun.fat4.cn/archives/pecl.php.net/get/mongodb-${MONGODB_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/mongodb; \
    docker-php-ext-install -j$(nproc) /tmp/mongodb; \
    rm -rf /tmp/mongodb; \
    # swoole
    mkdir /tmp/swoole; \
    curl http://upyun.fat4.cn/archives/pecl.php.net/get/swoole-${SWOOLE_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/swoole; \
    apk add --no-cache openssl-dev curl-dev; \
    docker-php-ext-configure /tmp/swoole --enable-openssl --enable-swoole-curl; \
    docker-php-ext-install -j$(nproc) /tmp/swoole; \
    rm -rf /tmp/swoole; \
    apk del .build-deps $PHPIZE_DEPS

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
