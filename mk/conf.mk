conf: ${CONF}

${CONF}: /etc/${@D}/
	exec bin/template env=Makefile conf/$@ >/etc/$@

.PHONY: conf ${CONF}
