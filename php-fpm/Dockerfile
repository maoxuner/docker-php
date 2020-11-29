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

ARG REDIS_VERSION=5.3.2
ARG GRPC_VERSION=1.33.1
ARG PROTOBUF_VERSION=3.14.0
ARG SWOOLE_VERSION=4.5.9

RUN set -ex; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    docker-php-source extract; \

    # redis
    mkdir /usr/src/php/ext/redis; \
    curl -sfL https://pecl.minio.fat4.cn/redis/${REDIS_VERSION}.tgz | tar -xz --strip-components=1 -C /usr/src/php/ext/redis; \
    docker-php-ext-install -j$(nproc) redis; \

    # grpc
    mkdir /usr/src/php/ext/grpc; \
    curl -sfL https://pecl.minio.fat4.cn/grpc/${GRPC_VERSION}.tgz | tar -xz --strip-components=1 -C /usr/src/php/ext/grpc; \
    apk add --no-cache linux-headers; \
    docker-php-ext-install -j$(nproc) grpc; \
    apk del linux-headers; \

    # protobuf
    mkdir /usr/src/php/ext/protobuf; \
    curl -sfL https://pecl.minio.fat4.cn/protobuf/${PROTOBUF_VERSION}.tgz | tar -xz --strip-components=1 -C /usr/src/php/ext/protobuf; \
    docker-php-ext-install -j$(nproc) protobuf; \

    # swoole
    mkdir /usr/src/php/ext/swoole; \
    curl -sfL https://pecl.minio.fat4.cn/swoole/${SWOOLE_VERSION}.tgz | tar -xz --strip-components=1 -C /usr/src/php/ext/swoole; \
    apk add --no-cache openssl-dev pcre-dev pcre2-dev zlib-dev; \
    docker-php-ext-configure swoole --enable-http2 --enable-mysqlnd --enable-openssl --enable-sockets --enable-swoole-json;\
    docker-php-ext-install -j$(nproc) swoole; \

    docker-php-source delete; \
    apk del .build-deps $PHPIZE_DEPS

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
