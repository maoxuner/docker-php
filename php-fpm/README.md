# PHP-FPM

基础镜像：`php:fpm-alpine`

## 使用示例

```yaml
version: "3"
services:
  php-fpm:
    container_name: php-fpm
    image: php-fpm
    build:
      context: .
      args:
        PHP_TAG: fpm-alpine
    environment:
      CRONTAB_CONFIG: /config/crontabs
      NGINX_CONFIG: /config/nginx
      SUPERVISOR_CONFIG: /config/supervisor
    volumes:
      - /path/to/application:/var/www/html
      - /path/to/crontabs/www-data:/config/crontabs/www-data
      - /path/to/nginx/config/default.conf:/config/nginx/default.conf
      - /path/to/supervisor/queue.ini:/config/supervisor/queue.ini
    network_mode: bridge
    ports:
      - 80:80
```

## 工具

```bash
Service Configuration Manager

Usage:
  service-configure SERVICE COMMAND [FILE]...

Available Services:
  nginx         Nginx
  crontab       Crond
  supervisor    Supervisord

Available Commands:
  load          Load service configurations
  reload        Load service configurations and reload service
  unload        Unload current configurations
  list          List all configurations
```
