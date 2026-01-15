repo = registry.cn-shanghai.aliyuncs.com/maoxuner/php

cri := $(shell command -v podman || command -v docker)

all: php5.image php7.image php8.image

php5.image: version=5.6.40
php5.image: php5 php5/Dockerfile
	$(cri) build --tag $(repo):$(version)-cli-alpine --build-arg=PHP_TAG=$(version)-cli-alpine $<
	$(cri) build --tag $(repo):$(version)-fpm-alpine --build-arg=PHP_TAG=$(version)-fpm-alpine $<
php7.image: version=7.4.33
php7.image: php7 php7/Dockerfile
	$(cri) build --tag $(repo):$(version)-cli-alpine --build-arg=PHP_TAG=$(version)-cli-alpine $<
	$(cri) build --tag $(repo):$(version)-fpm-alpine --build-arg=PHP_TAG=$(version)-fpm-alpine $<
php8.image: version=8.2.30
php8.image: php8 php8/Dockerfile
	$(cri) build --tag $(repo):$(version)-cli-alpine --build-arg=PHP_TAG=$(version)-cli-alpine $<
	$(cri) build --tag $(repo):$(version)-fpm-alpine --build-arg=PHP_TAG=$(version)-fpm-alpine $<

test: all clean

clean:
	$(cri) rmi -f $(repo):5.6.40-cli-alpine
	$(cri) rmi -f $(repo):5.6.40-fpm-alpine
	$(cri) rmi -f $(repo):7.4.33-cli-alpine
	$(cri) rmi -f $(repo):7.4.33-fpm-alpine
	$(cri) rmi -f $(repo):8.2.30-cli-alpine
	$(cri) rmi -f $(repo):8.2.30-fpm-alpine
