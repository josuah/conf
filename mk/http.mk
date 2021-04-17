CONF = httpd.conf

mk/http: ${CONF}

mk/http/sync:
mk/http/clean:

include mk/conf.inc
