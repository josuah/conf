BIN = hex2bin acme-cli dn42-filter dn42-roa dnssec hex2bin log \
  monitower mopen mtop mtrash mview netinfo pack pass ptree random \
  rcctl rctable rename snapshot syslogf template term totp wg-obsd \
  wg-ptp whois-expiry x-terminal-emulator x-www-browser x509 xdg-open \
  zone

CFLAGS = -std=c99 -Wall -Wextra -pedantic
PREFIX = /usr/local/bin

all: ${BIN}

.PHONY: .gitignore
.SUFFIXES: .c .awk .sh

.c:
	${CC} ${CFLAGS} -o ${PREFIX}/$@ $<

.sh:
	install -D -m555 -o0 -g0 $< ${PREFIX}/$@

.awk:
	install -D -m555 -o0 -g0 $< ${PREFIX}/$@
