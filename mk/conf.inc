${CONF}:
	exec mkdir -p /etc/${@D}
	exec bin/template conf/$@ >/etc/$@
