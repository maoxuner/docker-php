repo = maoxuner/php
tags = cli fpm
vers = 8

all: $(tags)

$(tags):
	docker build -t $(repo):$(vers)-$@-alpine --build-arg=PHP_TAG=$(vers)-$@-alpine .

test: all clean

clean:
	docker rmi -f $(foreach tag,$(tags),$(repo):$(vers)-$(tag)-alpine)
