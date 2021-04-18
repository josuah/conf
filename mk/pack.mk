mk/pack: ${CONF}
	exec mkdir -p /home/pack
	exec ln -sf "${PWD}/recipe" /home/pack

mk/pack/sync:
mk/pack/clean:
