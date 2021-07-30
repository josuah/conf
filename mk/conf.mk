conf: ${CONF}

${CONF}: /etc/${@D}/
	exec template env=Makefile conf/$@ >/etc/$@

.PHONY: conf ${CONF}
