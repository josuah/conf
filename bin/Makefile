CFLAGS = -std=c99 -Wall -Wextra -pedantic \
	-D_POSIX_C_SOURCE=200811L -D_BSD_SOURCE
LDFLAGS = -static
PREFIX = /usr/local/bin

BIN =	80 acme-cli ctl daemon daemonctl dn42-filter dn42-roa dnssec doc host \
	log monitower mopen mtop mtrash mview netinfo pack pass \
	pinentry-dmenu play ptree qemu random rcctl rctable rename \
	mailtube-xnotify mailtube-server syslogf template term \
	totp wg-obsd wg-ptp whois-expiry x-terminal-emulator x-www-browser \
	x509 xdg-open zone

all: ${BIN}

dwmstatus: dwmstatus.c
	${CC} ${CFLAGS} -I/usr/X11R6/include -L/usr/X11R6/lib -o ${PREFIX}/$@ $@.c -lX11

.SUFFIXES: .c .awk .sh

.c:
	${CC} ${CFLAGS} ${LDFLAGS} -o ${PREFIX}/$@ $<

.sh:
	install -D -m555 $< ${PREFIX}/$@

.awk:
	install -D -m555 $< ${PREFIX}/$@
