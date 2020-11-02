#!/bin/sh

exec >/etc/motd
printf '\n  %s\n\n' "$(uname -srnm)"

exec >/etc/crontab
cat /etc/crontab.d/*
pkill -HUP cron

exec >/etc/syslog.conf
cat /etc/syslog.d/*
sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs touch
sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs chmod 6400
sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs chown root:
pkill -HUP syslogd

exec >/etc/newsyslog.conf
cat /etc/newsyslog.d/*

exec >/etc/login.conf
cat /etc/login.d/*

exec >/etc/inetd.conf
cat /etc/inetd.d/*

exec >/etc/hosts
cat /etc/hosts.d/*

exec >/etc/pf.conf
cat /etc/pf.d/*

exec >/etc/dhcpd.conf
cat /etc/dhcpd.d/*

true
