#!/bin/sh -eu
exec x-www-search "https://duckduckgo.com/?q=$(xsel -o)"
