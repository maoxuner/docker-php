.PHONY: clean

all: cli fpm

test: all clean

cli:
	docker build -t maoxuner/php:7-cli-alpine --build-arg=PHP_TAG=7-cli-alpine .

fpm:
	docker build -t maoxuner/php:7-fpm-alpine --build-arg=PHP_TAG=7-fpm-alpine .

clean:
	docker rmi -f \
		php:7-cli-alpine \
		php:7-fpm-alpine \
		maoxuner/php:7-cli-alpine \
		maoxuner/php:7-fpm-alpine \
		> /dev/null 2>&1
