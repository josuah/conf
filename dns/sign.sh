#!/bin/sh -eu

export KSK="$(ldns-keygen -k -a RSASHA512 -b 4096 "$zone")"
export ZSK="$(ldns-keygen -a RSASHA512 -b 4096 "$zone")"

ldns-sigzone -n -s "$(openssl rand -base64 24)"
