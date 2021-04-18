HOM3 = root@shag root@corax josuah@corax root@pelios josuah@shag \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam

mk/home:
	exec cp -r home/.??* ${HOME}

mk/home/sync: ${HOM3}
${HOM3}:
	exec rsync -vrt home/ $@:

mk/home/clean:
