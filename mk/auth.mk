AUTH = nlams1 frlil1 term1 dis-sys-2
HOM3 = \
  root@term1 josuah@term1 \
  root@frlil1 backup@frlil1 \
  root@nlams1 josuah@nlams1 \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam git@git.z0.is \
  root@dis-sys-2 jdemangeon@dis-sys-2

mk/auth:
mk/auth/sync: ${AUTH} ${HOM3}

${AUTH}:
	exec rsync -vrt --delete ${PWD}/* $@:${PWD}

${HOM3}:
	exec rsync -vrt home/ $@:
