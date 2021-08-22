CONF = login.conf newsyslog.conf relayd.conf relayd/tls.conf pf.conf \
  usermgmt.conf hostname.wg0

include conf/mk/conf.mk

conf: pf/whitelist pf/blacklist pf/local.conf

pf/whitelist pf/blacklist pf/local.conf: pf
	exec touch $@

relayd pf:
	exec mkdir -p $@

relayd/local.conf: relayd
	exec touch $@
