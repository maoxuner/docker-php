#!/bin/sh

supervisord -j /run/supervisord.pid

exec php-fpm
