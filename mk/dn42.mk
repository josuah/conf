RPKI = /var/db/rpki-client/dn42
REPO = /home/dn42/registry
URL = git@git.dn42.dev:dn42/registry.git
CONF = bgpd/dn42.conf
include mk/conf.inc

mk/dn42: ${CONF} ${REPO}/.git

mk/dn42/sync: ${REPO}/.git
	exec su -l dn42 -c 'exec git -C ${REPO} fetch origin'
	exec su -l dn42 -c 'exec git -C ${REPO} reset --hard origin/master'
	exec dn42-roa ${REPO}/data/route/* ${REPO}/data/route6/* >${RPKI}.tmp
	exec mv ${RPKI}.tmp ${RPKI}

${REPO}/.git: /home/dn42
	exec su -l dn42 -c 'exec git clone ${URL} ${REPO}'

/home/dn42:
	exec useradd -m dn42

mk/dn42/clean:
	exec rm -f ${RPKI}.tmp
