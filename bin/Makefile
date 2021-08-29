D = -D_POSIX_C_SOURCE=200811L -D_BSD_SOURCE
CFLAGS = $D -std=c99 -Wall -Wextra -pedantic 
LDFLAGS = -static
PREFIX = /usr/local/bin

BIN = bin2hex ctl hex2bin acme-cli daemon dn42-filter dn42-roa dnssec \
  hex2bin host log menu monitower mopen mtop mtrash mview netinfo pack pass \
  play ptree random rcctl rctable rename snapshot syslogf template term totp \
  wg-obsd wg-ptp whois-expiry x-terminal-emulator x-www-browser \
  x509 xdg-open zone

all: ${BIN}

.PHONY: .gitignore
.SUFFIXES: .c .awk .sh

.c:
	${CC} ${CFLAGS} ${LDFLAGS} -o ${PREFIX}/$@ $<

.sh:
	install -D -m555 $< ${PREFIX}/$@

.awk:
	install -D -m555 $< ${PREFIX}/$@
