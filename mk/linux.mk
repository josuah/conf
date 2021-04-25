CONF = netstart
include mk/conf.inc

mk/linux: ${CONF}
	rm -f /etc/hostname.wg*
	for x in /etc/wireguard/wg*.conf; do if=$${x##*/} if=$${if%.conf}; \
		env ${ENV} template conf/linux.wg >/etc/hostname.$$if; \
	done
	chmod +x /etc/hostname.*

mk/linux/sync:
mk/linux/clean:
