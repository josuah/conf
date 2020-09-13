#!/bin/sh -eux

mkdir -p /etc/qmail /var/spool
ln -fs /var/qmail/alias /var/qmail/control /var/qmail/users /etc/qmail
ln -fs /var/qmail/queue /etc/qmail/qmail
mv -f /etc/qmail/qmail /var/spool

hostname >/etc/qmail/control/me
