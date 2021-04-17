CONF = relayd.conf

mk/tls: ${CONF}
	exec ln -sf /etc/ssl/$$(hostname).crt /etc/ssl/hostname.crt
	exec ln -sf /etc/ssl/private/$$(hostname).key /etc/ssl/private/hostname.key

mk/tls/sync:
mk/tls/clean:

include mk/conf.inc
