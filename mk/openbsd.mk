CONF = hostname.wg0 \
  login.conf newsyslog.conf pf.conf rad.conf relayd.conf relayd/tls.conf \
  usermgmt.conf
include conf/mk/conf.mk

conf: pf/whitelist pf/blacklist pf/local.conf

pf/whitelist pf/blacklist pf/local.conf: pf
	touch $@

relayd pf:
	mkdir -p $@

relayd/local.conf: relayd
	touch $@
