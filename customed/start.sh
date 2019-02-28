#!/bin/sh

set -e

copy_config()
{
    source="${1}"
    target="${2}"

    rm -rf ${target}/*

    if [ -f "${source}" ]; then
        cp "${source}" ${target}/
    fi
    if [ -d "${source}" ]; then
        cp -a "${source}"/. ${target}/
    fi
}

# 启动supervisor
if [ -n "${SUPERVISOR_CONFIG}" ]; then
    copy_config "${SUPERVISOR_CONFIG}" /etc/supervisor.d
    supervisord
fi

# 启动定时任务
if [ -n "${CRONTAB_CONFIG}" ]; then
    copy_config "${CRONTAB_CONFIG}" /etc/crontabs
    crond
fi

# 启动nginx
if [ -n "${NGINX_CONFIG}" ]; then
    copy_config "${NGINX_CONFIG}" /etc/nginx/conf.d
    nginx
fi

# 启动fpm
exec php-fpm
