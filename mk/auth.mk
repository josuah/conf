AUTH = shag pelios corax dis-sys-2
HOM3 = \
  root@corax josuah@corax \
  root@pelios backup@pelios \
  root@shag josuah@shag \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam git@git.z0.is \
  root@dis-sys-2 jdemangeon@dis-sys-2

mk/auth:
mk/auth/sync: ${AUTH} ${HOM3}
mk/auth/clean:

${AUTH}:
	exec rsync -vrt --delete ${PWD}/* $@:${PWD}

${HOM3}:
	exec rsync -vrt home/ $@:
