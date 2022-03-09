CONF =	tor/torrc
include conf/mk/conf.mk

conf: tor

tor:
	ln -sf conf/tor .
