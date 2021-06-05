SYNC = mk bin conf
SYNC_CONF = lil1 ams1 term1 # dis-sys-2
SYNC_HOME = root@term1 backup@term1 josuah@term1 root@lil1 josuah@lil1 \
 backup@lil1 git@lil1 josuah@bitreich.org josuah@server10.openbsd.amsterdam \
 root@ams1 josuah@ams1
# root@dis-sys-2 jdemangeon@dis-sys-2

sync: ${SYNC_CONF} ${SYNC_HOME}

${SYNC_CONF}:
	exec rsync -vrt --delete ${SYNC} $@:${PWD}

${SYNC_CONF:=+}: $*
	exec ssh $* make -C /etc

${SYNC_HOME}:
	exec rsync -vrt conf/home/ $@:

.SUFFIXES: +
