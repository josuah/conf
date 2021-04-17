CONF = hosts syslog.conf crontab profile
BASE = shag corax pelios

mk/base:
	exec mkdir -p ${PREFIX}/bin
	exec ln -sf ${PWD}/bin/* ${PREFIX}/bin

mk/base/sync: ${BASE}
${BASE}:
	exec rsync -vtr --delete ${PWD}/* $@:${PWD}

mk/base/clean:

include mk/conf.inc
