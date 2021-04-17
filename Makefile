PREFIX = /usr/local

MOD = mk/dns mk/mail mk/base mk/http mk/monit mk/tls mk/dot mk/pack

all: ${MOD}
sync: ${MOD:=/sync}
clean: ${MOD:=/clean}

include = ${MOD:=.mk}
include ${include}
