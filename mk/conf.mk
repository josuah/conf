all: ${CONF}

${CONF}: /etc/${@D}/
	exec env ${ENV} bin/template conf/$@ >/etc/$@
