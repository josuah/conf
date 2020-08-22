#!/bin/sh -eux
mkdir -p "/etc/qmail/control"
hostname >/etc/qmail/control/me
