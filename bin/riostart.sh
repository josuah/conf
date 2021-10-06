#!/bin/sh -e
host=$(printf '%s\n' \
lil1.z0.is rpi1.z0.is lap1.z0.is lap2.z0.is lap3.z0.is lap4.z0.is \
9p.sdf.org \
| menu)
case "$host" in (*.z0.is) auth=lil1.z0.is ;; (*) auth=$host ;; esac
drawterm -h "$host" -a "$auth" &
