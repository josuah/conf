#!/bin/sh -eu

read mac </home/vm/$1.mac

umask 007
mkdir -p /var/run/vnc /var/log/qemu
chgrp vnc /var/run/vnc
chmod g+s /var/run/vnc

sed 's/#.*//' /etc/qemu/$1.conf \
| xargs -t daemon "qemu-system-${ARCH:-x86_64}" \
  -netdev tap,id=n0 \
  -device virtio-net,netdev=n0,mac="$mac" \
  -vnc unix:"/var/run/vnc/$1.sock" \
  -drive file="/home/vm/$1.qcow",media=disk

echo vncviewer "/var/run/vnc/$1.sock"
