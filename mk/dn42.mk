DN42_URL = git@git.dn42.dev:dn42/registry.git
DN42_DIR = /home/dn42/registry
DN42_DATA = ${DN42_DIR}/data
DN42_FILTER = ${DN42_DATA}/filter.txt ${DN42_DATA}/filter6.txt

dn42: ${DN42_DIR}
	doas -u dn42 git -C ${DN42_DIR} fetch origin
	doas -u dn42 git -C ${DN42_DIR} reset --hard origin/master

conf: conf/bgpd/roa.conf
conf/bgpd/roa.conf: ${DN42_DATA}
	dn42-roa ${DN42_DATA}/route/* ${DN42_DATA}/route6/* >$@.tmp
	mv $@.tmp $@

conf: conf/bgpd/permit.conf
conf/bgpd/permit.conf: ${DN42_FILTER}
	dn42-filter permit ${DN42_FILTER} >$@

conf: conf/bgpd/deny.conf
conf/bgpd/deny.conf: ${DN42_FILTER}
	dn42-filter deny ${DN42_FILTER} >$@

${DN42_FILTER} ${DN42_DATA}: ${DN42_DIR}

${DN42_DIR}: /home/dn42
	doas -u dn42 git clone ${DN42_URL} ${DN42_DIR}

/home/dn42:
	useradd -m dn42
