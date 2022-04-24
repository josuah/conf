SYNC_CONF = ams1 lap1
SYNC_HOME = root@lap1 josuah@lap1 root@ams1 josuah@ams1 \
	josuah@bitreich.org josuah@server10.openbsd.amsterdam

sync: ${SYNC_HOME}
${SYNC_HOME}:
	rsync -lvrt conf/home/ $@:.

sync: ${SYNC_CONF}
${SYNC_CONF}:
	rsync -lvrt --delete conf/* $@:${PWD}/conf/
	ssh $@ make -C /etc
