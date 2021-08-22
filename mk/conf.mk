conf: ${CONF}

${CONF}: ${@D}
	template env=Makefile conf/$@ >$@

.PHONY: conf ${CONF}
