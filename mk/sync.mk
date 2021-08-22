SYNC_CONF = lil1 ams1 tyo1 term1 # dis-sys-2
SYNC_HOME = root@term1 backup@term1 josuah@term1 root@lil1 josuah@lil1 \
 backup@lil1 git@lil1 josuah@bitreich.org josuah@server10.openbsd.amsterdam \
 root@ams1 josuah@ams1
# root@dis-sys-2 jdemangeon@dis-sys-2

sync: ${SYNC_CONF} ${SYNC_HOME}

${SYNC_CONF}:
	rsync -vrt --delete conf/* $@:${PWD}/conf/

${SYNC_CONF:=+}: $*
	ssh $* make -C /etc

${SYNC_HOME}:
	rsync -vrt conf/home/ $@:

.SUFFIXES: +
