PREFIX = /usr/local

include .local.mk
include = ${MOD:=.mk}
include ${include}

all: ${MOD}
sync: ${MOD:=/sync}
clean: ${MOD:=/clean}
