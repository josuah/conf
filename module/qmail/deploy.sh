#!/bin/sh -eux

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' INT TERM EXIT HUP

mkdir -p "/etc/qmail/control"
hostname >/etc/qmail/control/me

cd /etc/usr/
