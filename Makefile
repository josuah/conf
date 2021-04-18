PREFIX = /usr/local

include .local.mk

all: ${MOD}
sync: ${MOD:=/sync}
clean: ${MOD:=/clean}

include = ${MOD:=.mk}
include ${include}
