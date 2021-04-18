CONF = bgpd/dn42.conf
include mk/conf.inc

mk/dn42: ${CONF} /home/dn42/registry

/home/dn42/registry:
	exec su -l dn42 -c 'exec git clone https://git.dn42.dev/registry $@'

/home/dn42:
	exec useradd -m dn42

/var/db/rpki-client/dn42:
	exec dn42

mk/dn42/sync:
	exec su -l dn42 -c 'exec git -C /home/dn42/registry fetch'
	exec su -l dn42 -c 'exec git -C /home/dn42/registry reset --hard origin/master'

mk/dn42/clean:
