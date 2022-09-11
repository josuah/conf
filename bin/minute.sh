#!/bin/sh
set -u -o pipefail

secret=$(pass show panoramix-labs.fr/tinyvision-ai-inc)
dir=/var/www/htdocs/panoramix-labs/tinyvision-ai-inc/$secret/$(date +%Y-%m-%d)
ssh -t ams1 "mkdir -p '$dir' && cd '$dir' && /usr/local/bin/vi index.md && make -C ../../.."
