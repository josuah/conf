RPKI = conf/bgpd/roa.conf
REPO = /home/dn42/registry
FILTER = ${REPO}/data/filter.txt ${REPO}/data/filter6.txt
URL = git@git.dn42.dev:dn42/registry.git

mk/dn42: ${RPKI} conf/bgpd/prefix-permit.conf conf/bgpd/prefix-deny.conf

mk/dn42/sync: ${REPO}/.git
	exec su -l dn42 -c 'exec git -C ${REPO} fetch origin'
	exec su -l dn42 -c 'exec git -C ${REPO} reset --hard origin/master'
	exec make mk/dn42

mk/dn42/clean:
	exec rm -f ${RPKI}.tmp

${RPKI}: ${REPO}/.git
	exec dn42-roa ${REPO}/data/route/* ${REPO}/data/route6/* >$@.tmp
	exec mv ${RPKI}.tmp ${RPKI}

conf/bgpd/prefix-permit.conf: ${FILTER}
	exec dn42-filter permit ${FILTER} >$@

conf/bgpd/prefix-deny.conf: ${FILTER}
	exec dn42-filter deny ${FILTER} >$@

${FILTER} ${REPO}/.git: /home/dn42
	exec su -l dn42 -c 'exec git clone ${URL} ${REPO}'

/home/dn42:
	exec useradd -m dn42
