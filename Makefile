.PHONY: clean

all: cli fpm

test: all clean

cli:
	docker build -t maoxuner/php:8-cli-alpine --build-arg=PHP_TAG=8-cli-alpine .

fpm:
	docker build -t maoxuner/php:8-fpm-alpine --build-arg=PHP_TAG=8-fpm-alpine .

clean:
	docker rmi -f \
		php:8-cli-alpine \
		php:8-fpm-alpine \
		maoxuner/php:8-cli-alpine \
		maoxuner/php:8-fpm-alpine \
		> /dev/null 2>&1
