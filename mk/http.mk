CONF =	httpd.conf httpd/acme.conf httpd/default.conf
include conf/mk/conf.mk

httpd.conf: httpd/acme.conf httpd/default.conf

httpd:
	mkdir -p $@
