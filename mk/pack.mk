mk/pack:
	exec mkdir -p /dot/pack
	exec rm -f recipe
	exec ln -s "${PWD}/pack" recipe
	exec mv recipe /dot/pack

mk/pack/clean:
mk/pack/sync:
