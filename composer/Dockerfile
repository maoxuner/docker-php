ARG PHP_TAG=7.3-cli-alpine

FROM maoxuner/php:${PHP_TAG}

ARG COMPOSER_VERSION=1.8.5
ARG INSTALLER_COMMIT=cb19f2aa3aeaa2006c0cd69a7ef011eb31463067
ARG INSTALLER_HASH=48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION ${COMPOSER_VERSION}

RUN set -ex \
    && apk add --no-cache tini bash \
    && php -r "copy('https://raw.githubusercontent.com/composer/getcomposer.org/${INSTALLER_COMMIT}/web/installer', '/tmp/composer-setup.php');" \
    && php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '${INSTALLER_HASH}') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php /tmp/composer-setup.php --install-dir=/usr/local/bin --version=${COMPOSER_VERSION} --filename=composer \
    && chmod +x /usr/local/bin/composer \
    && php -r "unlink('/tmp/composer-setup.php');"

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /app

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["composer"]
