repo = docker.io/maoxuner/php
tags = cli fpm
vers = 8

cri := $(shell command -v podman || command -v docker)
os = linux
arch = amd64

all: $(tags)

$(tags):
	$(cri) build -t $(repo):$(vers)-$@-alpine --build-arg=PHP_TAG=$(vers)-$@-alpine --platform=$(os)/$(arch) .

test: all clean

clean:
	$(cri) rmi -f $(foreach tag,$(tags),$(repo):$(vers)-$(tag)-alpine)
