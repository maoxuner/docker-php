# 定制 PHP

[![Gitee Repo](https://badgen.net/badge/gitee/php7?icon=git)](https://gitee.com/maoxuner/docker-php/tree/php7)
[![Docker Registry](https://badgen.net/badge/docker/latest?icon=docker)](https://hub.docker.com/r/maoxuner/php)
[![Build Status](https://img.shields.io/drone/build/maoxuner/docker-php/php7?logo=drone&server=https://drone.fat4.cn)](https://drone.fat4.cn/maoxuner/docker-php)

安装了常用组件的定制镜像，避免项目使用时构建镜像。PHP 版本`7.4.33`

# PHP 扩展

- redis(5.3.7)
- mongodb(1.15.1)
- grpc(1.52.1)
- protobuf(3.22.1)
- swoole([4.8.12](https://wiki.swoole.com/#/environment "4.8版本需要php-7.2或更高版本，5.0版本需要php-8.0或更高版本"))
- opcache
- pcntl
- mysqli
- pdo_mysql
- pdo_pgsql
- zip(1.15.6)
- bz2
- gd
- sockets
- intl
- bcmath

# 其他

- roadrunner(2.12.3)
- composer(2.x)
