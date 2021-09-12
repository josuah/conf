#!/bin/sh -eu

read mac </var/vm/mac/$1

umask 007
mkdir -p /var/run/qemu
chgrp qemu /var/run/qemu
chmod g+s /var/run/qemu

sed 's/#.*//' /etc/qemu/$1.conf \
| xargs -t daemon "qemu-system-${ARCH:-x86_64}" \
  -netdev tap,id=n0 \
  -device virtio-net,netdev=n0,mac="$mac" \
  -vnc unix:"/var/run/qemu/$1.vnc.sock" \
  -drive file="/var/vm/disk/$1.img",format=raw,media=disk

echo vncviewer "/var/run/qemu/$1.vnc.sock"
