ARG PHP_TAG=fpm-alpine

FROM php:${PHP_TAG}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN set -ex; \
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

ARG REDIS_VERSION=5.3.4
ARG GRPC_VERSION=1.41.0
ARG PROTOBUF_VERSION=3.19.0
ARG SWOOLE_VERSION=4.8.0
ARG ROAD_RUNNER_VERSION=2.5.2

RUN set -ex; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \

    # redis
    mkdir /tmp/redis; \
    curl -sfL https://archives.minio.fat4.cn/pecl/redis-${REDIS_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/redis; \
    docker-php-ext-install -j$(nproc) /tmp/redis; \

    # grpc
    mkdir /tmp/grpc; \
    curl -sfL https://archives.minio.fat4.cn/pecl/grpc-${GRPC_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/grpc; \
    apk add --no-cache linux-headers; \
    CPPFLAGS="-Wno-maybe-uninitialized" docker-php-ext-install -j$(nproc) /tmp/grpc; \
    apk del linux-headers; \

    # protobuf
    mkdir /tmp/protobuf; \
    curl -sfL https://archives.minio.fat4.cn/pecl/protobuf-${PROTOBUF_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/protobuf; \
    docker-php-ext-install -j$(nproc) /tmp/protobuf; \

    # swoole
    mkdir /tmp/swoole; \
    curl -sfL https://archives.minio.fat4.cn/pecl/swoole-${SWOOLE_VERSION}.tgz | tar -xz --strip-components=1 -C /tmp/swoole; \
    apk add --no-cache openssl-dev pcre-dev pcre2-dev zlib-dev; \
    docker-php-ext-configure /tmp/swoole --enable-http2 --enable-mysqlnd --enable-openssl --enable-sockets --enable-swoole-json; \
    docker-php-ext-install -j$(nproc) /tmp/swoole; \

    apk del .build-deps $PHPIZE_DEPS

RUN set -ex; \
    mkdir /opt/roadrunner; \
    curl -sfL https://archives.minio.fat4.cn/roadrunner/roadrunner-${ROAD_RUNNER_VERSION}-linux-amd64.tar.gz | tar -xz --strip-components=1 -C /opt/roadrunner; \
    ln -s /opt/roadrunner/rr /usr/local/bin/rr

RUN set -ex; \
    apk add --no-cache \
        nginx supervisor; \
    mkdir -p /run/nginx; \
    ln -s /dev/sdtout /var/log/nginx/access.log; \
    ln -s /dev/sdtout /var/log/nginx/error.log; \
    mkdir /etc/supervisor.d; \
    sed -i '/^;pidfile/ s/^;//' /etc/supervisord.conf; \
    sed -i '/^files\ =/ s/.*/files\ =\ \/etc\/supervisor\.ini\ \/etc\/supervisor\.d\/\*\.ini/' /etc/supervisord.conf

COPY supervisor.ini /etc/supervisor.ini

COPY bin/* /usr/local/bin/

CMD ["start.sh"]
