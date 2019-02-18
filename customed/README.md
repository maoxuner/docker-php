# PHP + Supervisor + Cron + Nginx

## 服务

- supervisor
- cron
- nginx

## 环境变量

- 环境变量的值可以是容器内的一个文件或目录
- 可以是相对于容器`WORKDIR`（/var/www/html）的相对路径，也可以是绝对路径
- 环境变量未设置时，对应的服务不会启动

### `SUPERVISOR_CONFIG`

supervisor配置文件或者目录

### `CRONTAB_CONFIG`

crontab配置文件或者目录，注意文件名是docker内执行定时任务用户的用户名。

### `NGINX_CONFIG`

nginx配置文件或者目录
