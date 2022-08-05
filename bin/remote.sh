#!/bin/sh
# open a remote graphical program

ssh='ssh -CYt josuah@ams1'

case $1 in
(magic) exec $ssh magic -noconsole -T sky130A ;;
(xschem) exec $ssh xschem ;;
(*) exec sed -nr "s/^\(([a-z]+)\).*/ ${0##*/} \1/p" "$0" ;;
esac
