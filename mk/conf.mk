${CONF}:
	exec mkdir -p /etc/${@D}
	exec env ${ENV} bin/template conf/$@ >/etc/$@
