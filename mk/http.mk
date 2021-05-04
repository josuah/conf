CONF = httpd.conf
include mk/conf.mk

mk/http: ${CONF}
mk/http/sync:
mk/http/clean:
