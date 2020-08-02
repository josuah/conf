NAME = icecast
CONF = icecast.xml
ENV = /etc/env/voice/*

all: conf
conf: /etc/env/voice/ICECAST_PASS

/etc/env/voice/ICECAST_PASS:
	dd if=/dev/urandom bs=16 count=1 2>/dev/null \
	| od -x -A n | tr -cd '0-9a-z' >$@
	echo >>$@

include ../Makefile.template
