CFLAGS = -std=c99 -Wall -Wextra -pedantic \
	-D_POSIX_C_SOURCE=200811L -D_BSD_SOURCE
LDFLAGS = -static
PREFIX = /usr/local/bin

all: \
256 acme-cli align backup-clean backup-mirror backup-rsync bin ctl \
daemon daemonctl dmenu_dir dn42-filter dn42-roa dnssec doc edit git-less \
hex host html log mailtube-server mailtube-xnotify marchive mirror monitower \
mopen mtop mtrash mview netinfo notify-send pass pack pdf-sign pkg_menu play \
remote sfeed_maildir syslogf template term \
totp webcam wg-obsd wg-ptp whois-expiry worldclock x-terminal-emulator \
x-www-browser x509 xdg-plumb xdg-open \
zone

dwmstatus: dwmstatus.c
	${CC} ${CFLAGS} -I/usr/X11R6/include -L/usr/X11R6/lib -o ${PREFIX}/$@ $@.c -lX11

.SUFFIXES: .c .awk .sh

.c:
	${CC} ${CFLAGS} ${LDFLAGS} -o ${PREFIX}/$@ $<

.sh:
	install -D -m555 $< ${PREFIX}/$@

.awk:
	install -D -m555 $< ${PREFIX}/$@
