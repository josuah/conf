#!/bin/sh -e
export PASS="$(pass show "z0.is/$USER")"
drawterm -h 10.0.9.8 -a 10.0.9.8 -c rio -b -i riostart &
