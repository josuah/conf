conf: ${CONF}

${CONF}: ${@D}
	exec template env=Makefile conf/$@ >$@

.PHONY: conf ${CONF}
