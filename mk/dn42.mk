DN42_URL = git@git.dn42.dev:dn42/registry.git
DN42_DIR = /home/dn42/registry
DN42_DATA = ${DN42_DIR}/data
DN42_FILTER = ${DN42_DATA}/filter.txt ${DN42_DATA}/filter6.txt

conf: conf/bgpd/roa.conf conf/bgpd/permit.conf conf/bgpd/deny.conf
sync: dn42/sync

dn42/sync: ${DN42_DIR}
	exec doas -u dn42 git -C ${DN42_DIR} fetch origin
	exec doas -u dn42 git -C ${DN42_DIR} reset --hard origin/master

conf/bgpd/roa.conf: ${DN42_DATA}
	exec dn42-roa ${DN42_DATA}/route/* ${DN42_DATA}/route6/* >$@.tmp
	exec mv $@.tmp $@

conf/bgpd/permit.conf: ${DN42_FILTER}
	exec dn42-filter permit ${DN42_FILTER} >$@

conf/bgpd/deny.conf: ${DN42_FILTER}
	exec dn42-filter deny ${DN42_FILTER} >$@

${DN42_FILTER} ${DN42_DATA}: ${DN42_DIR}

${DN42_DIR}: /home/dn42
	exec doas -u dn42 git clone ${DN42_URL} ${DN42_DIR}

/home/dn42:
	exec useradd -m dn42
