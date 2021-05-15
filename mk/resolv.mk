CONF = unbound.conf

include mk/conf.mk

unbound.conf: /etc/unbound.conf
/etc/unbound.conf:
	ln -sf /var/unbound/etc/unbound.conf $@
