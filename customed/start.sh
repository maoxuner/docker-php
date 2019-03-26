#!/bin/sh

set -e

copy_config()
{
    source="${1}"
    target="${2}"

    # 删除旧的文件
    rm -rf ${target}/*

    # 复制文件或目录
    if [ -f "${source}" ]; then
        cp "${source}" ${target}/
    fi
    if [ -d "${source}" ]; then
        cp -a "${source}"/. ${target}/
    fi

    # 修复文件或目录权限
    find ${target} -type d -exec chmod 755 {} \;
    find ${target} -type f -exec chmod 644 {} \;
    chown -R root:root ${target}
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
