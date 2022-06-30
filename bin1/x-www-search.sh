#!/bin/sh -eu
exec x-www-browser "https://duckduckgo.com/?q=$(xsel -o)"
