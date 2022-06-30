#!/bin/sh -eu
exec x-www-browser "https://en.wikipedia.org/wiki/$(xsel -o)"
