SYNC_CONF = ams1 lil1 term1 #dis-sys-2
SYNC_HOME = \
  root@term1 josuah@term1 \
  root@lil1 backup@lil1 \
  root@ams1 josuah@ams1 \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam git@git.z0.is \
  #root@dis-sys-2 jdemangeon@dis-sys-2

sync: ${SYNC_CONF} ${SYNC_HOME}

${SYNC_CONF}:
	exec rsync -vrt --delete ${PWD}/[a-z]* $@:${PWD}

${SYNC_HOME}:
	exec rsync -vrt home/ $@:
