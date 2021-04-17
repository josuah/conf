CONF = httpd.conf

http: ${CONF}

mk/http:
mk/http/sync:
mk/http/clean:

include mk/conf.inc
