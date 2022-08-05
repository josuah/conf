CFLAGS = -std=c99 -Wall -Wextra -pedantic \
	-D_POSIX_C_SOURCE=200811L -D_BSD_SOURCE
LDFLAGS = -static
PREFIX = /usr/local/bin
BIN =	acme-cli align backup-clean backup-mirror backup-rsync bin ctl daemon \
	daemonctl dmenu_dir dn42-filter dn42-roa dnssec doc git-less hex host edit \
	html log mailtube-server mailtube-xnotify monitower mopen mtop \
	mtrash mview netinfo notify-send pack pdf-sign pkg_menu play remote sfeed_maildir \
	sha256dedup sha256mirror syslogf template term totp webcam wg-obsd wg-ptp whois-expiry \
	worldclock x-terminal-emulator x-www-browser x-www-search x-www-wiki x509 \
	xdg-get xdg-open xdg-sync zone

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
