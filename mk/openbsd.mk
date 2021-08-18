CONF = login.conf newsyslog.conf relayd.conf relayd/tls.conf pf.conf \
  usermgmt.conf hostname.wg0

include conf/mk/conf.mk

conf: /etc/pf/whitelist /etc/pf/blacklist /etc/pf/local.conf

/etc/pf/whitelist /etc/pf/blacklist /etc/pf/local.conf:
	exec mkdir -p ${@D}
	exec touch $@
