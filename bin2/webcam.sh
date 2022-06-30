#!/bin/sh -eu
exec doas video -f "/dev/video${1:-1}"
