#!/bin/sh

service-configure crontab load
service-configure nginx load
service-configure supervisor load

exec supervisord -n
