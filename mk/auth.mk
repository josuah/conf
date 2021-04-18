AUTH = shag pelios corax
HOM3 = root@shag root@corax josuah@corax root@pelios josuah@shag \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam

mk/auth:
mk/auth/sync: ${AUTH} ${HOM3}
mk/auth/clean:

${AUTH}:
	exec rsync -vrt --delete ${PWD}/* $@:${PWD}

${HOM3}:
	exec rsync -vrt home/ $@:
