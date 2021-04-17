DOT = root@shag root@corax josuah@corax root@pelios josuah@shag \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam

mk/dot:
	exec cp -r home/.??* ${HOME}

mk/dot/sync: ${DOT}
${DOT}:
	exec rsync -vtr home/ $@:

mk/dot/clean:
