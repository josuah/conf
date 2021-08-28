#!/bin/sh -eu
# wrapper around dmenu with custom font and color

exec dmenu -sf "#ffffff" -sb "#005577" -nf "#bababa" -nb "#222222" \
  -fn terminus:pixelsize=16 "$@"
