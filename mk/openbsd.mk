CONF = login.conf newsyslog.conf relayd.conf relayd/tls.conf pf.conf \
  usermgmt.conf hostname.wg0

include conf/mk/conf.mk

conf: pf/whitelist pf/blacklist pf/local.conf

relayd:
	exec mkdir -p $@

pf/whitelist pf/blacklist pf/local.conf:
	exec mkdir -p ${@D}
	exec touch $@
