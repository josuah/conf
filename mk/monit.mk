CONF = monitower.conf

monit: ${CONF}

mk/monit:
mk/monit/sync:
mk/monit/clean:

include mk/conf.inc
