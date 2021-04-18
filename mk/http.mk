CONF = httpd.conf
include mk/conf.inc

mk/http: ${CONF}
mk/http/sync:
mk/http/clean:
