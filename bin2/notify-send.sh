#!/bin/sh -eu
exec echo "$*" >$XNOTIFY_FIFO
