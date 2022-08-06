ARG PHP_TAG=cli-alpine

FROM php:${PHP_TAG}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories

RUN set -ex; \
    apk add --no-cache \
        postgresql-dev \
        libzip-dev bzip2-dev \
        libpng-dev libjpeg-turbo-dev freetype-dev \
        icu-dev; \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/; \
    docker-php-ext-install -j$(nproc) \
        opcache \
        mysqli pdo_mysql pdo_pgsql \
        zip bz2 \
        gd sockets \
        intl bcmath

ARG REDIS_VERSION=5.3.7
ARG GRPC_VERSION=1.48.0
ARG PROTOBUF_VERSION=3.21.4
ARG SWOOLE_VERSION=5.0.0
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
    apk add --no-cache openssl-dev pcre-dev pcre2-dev zlib-dev; \
    docker-php-ext-configure /tmp/swoole --enable-http2 --enable-mysqlnd --enable-openssl --enable-sockets --enable-swoole-json; \
    docker-php-ext-install -j$(nproc) /tmp/swoole; \
    rm -rf /tmp/swoole; \
    apk del .build-deps $PHPIZE_DEPS

ARG ROAD_RUNNER_VERSION=2.10.7
RUN set -ex; \
    mkdir /opt/roadrunner; \
    curl -sfL https://ghproxy.com/https://github.com/roadrunner-server/roadrunner/releases/download/v${ROAD_RUNNER_VERSION}/roadrunner-${ROAD_RUNNER_VERSION}-linux-amd64.tar.gz | tar -xz --strip-components=1 -C /opt/roadrunner; \
    ln -s /opt/roadrunner/rr /usr/local/bin/rr

ARG COMPOSER_VERSION=2.3.10
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
RUN set -ex; \
    curl -sfL https://ghproxy.com/https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer; \
    chmod +x /usr/local/bin/composer
