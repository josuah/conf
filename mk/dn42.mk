REPO = /home/dn42/registry
FILTER = ${REPO}/data/filter.txt ${REPO}/data/filter6.txt
URL = git@git.dn42.dev:dn42/registry.git

mk/dn42: conf/bgpd/roa.conf conf/bgpd/permit.conf conf/bgpd/deny.conf

mk/dn42/sync: ${REPO}/.git
	exec doas -u dn42 git -C ${REPO} fetch origin
	exec doas -u dn42 git -C ${REPO} reset --hard origin/master
	exec make mk/dn42

conf/bgpd/roa.conf: ${REPO}/.git
	exec dn42-roa ${REPO}/data/route/* ${REPO}/data/route6/* >$@.tmp
	exec mv $@.tmp $@

conf/bgpd/permit.conf: ${FILTER}
	exec dn42-filter permit ${FILTER} >$@

conf/bgpd/deny.conf: ${FILTER}
	exec dn42-filter deny ${FILTER} >$@

/home/dn42:
	exec useradd -m dn42

${FILTER} ${REPO}/.git: /home/dn42
	exec doas -u dn42 git clone ${URL} ${REPO}
