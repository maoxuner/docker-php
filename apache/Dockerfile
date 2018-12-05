FROM php:7.2-apache

LABEL maintainer="maoxuner@126.com"

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libjpeg62-turbo-dev libpng-dev libfreetype6-dev \
        libbz2-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        mysqli pdo_mysql zip bz2 gd sockets

RUN a2enmod rewrite ssl

EXPOSE 443
